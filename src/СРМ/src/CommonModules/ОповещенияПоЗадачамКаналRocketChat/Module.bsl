Процедура ВыполнитьОтправкуСообщения(Сообщение, УчетнаяЗаписьОповещений, ОписаниеОшибки, НастройкиОтправкиОповещения) Экспорт
	Если Сообщение.Получатель.Количество() = 0 Тогда
		ОписаниеОшибки  = НСтр(
			"ru = 'Сообщение не может быть отправлено сразу, т.к необходимо ввести адрес электронной почты.'");
		Возврат;
	КонецЕсли;

	УчетнаяЗапись=УчетнаяЗаписьОповещений.Настройка;

//	Прокси = Новый ИнтернетПрокси(ИСТИНА);

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-type", "application/json");
	Заголовки.Вставить("Accept", "application/json");
	
	// сначала авторизация
	URL = "api/v1/login";
	HTTPЗапрос = Новый HTTPЗапрос(URL, Заголовки);

	СтруктураЗапроса=Новый Структура;
	СтруктураЗапроса.Вставить("user", УчетнаяЗапись.Пользователь);
	СтруктураЗапроса.Вставить("password", УчетнаяЗапись.Пароль);

	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаJSONИзОбъекта(СтруктураЗапроса));

	Если УчетнаяЗапись.ИспользоватьHTTPS Тогда
		ssl = Новый ЗащищенноеСоединениеOpenSSL;
		HTTP = Новый HTTPСоединение(УчетнаяЗапись.Сервер, , , , , 60, SSL);
	Иначе
		HTTP = Новый HTTPСоединение(УчетнаяЗапись.Сервер, , , , , 60);
	КонецЕсли;
	Попытка
		ОтветHTTP = HTTP.ОтправитьДляОбработки(HTTPЗапрос);
	Исключение
		ОписаниеОшибки="Не удалось авторизоваться на сервере RocketChat " + ОписаниеОшибки();
		Возврат;
	КонецПопытки;

	Если ОтветHTTP.КодСостояния <> 200 Тогда
		ОписаниеОшибки="Ошибка выполнения команды: " + ОтветHTTP.ПолучитьТелоКакСтроку();
		Возврат;
	КонецЕсли;

	ОтветJson = СтрокаJSONВОбъект(ОтветHTTP.ПолучитьТелоКакСтроку());
	Если Не (ОтветJson.Свойство("status") И ОтветJson.status = "success") Тогда
		ОписаниеОшибки="Не удалось авторизоваться на сервере RocketChat";
		Возврат;
	КонецЕсли;

	Токен = ОтветJson.data.authToken;
	ИД = ОтветJson.data.userId;
			
			// отправка сообщения
	URL = "api/v1/chat.postMessage";

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Accept", "application/json");
	Заголовки.Вставить("X-Auth-Token", Токен);
	Заголовки.Вставить("X-User-Id", ИД);

	ТекстСообщения="";
	Если ЗначениеЗаполнено(Сообщение.Тема) Тогда
		ТекстСообщения=Сообщение.Тема + Символы.ПС + Символы.ПС;
	КонецЕсли;
	ТекстСообщения=ТекстСообщения + Сообщение.Текст;

	Для Каждого Получатель Из Сообщение.Получатель Цикл
		ОписаниеСообщения = Новый Структура;
		ОписаниеСообщения.Вставить("channel", Получатель.Адрес);
		ОписаниеСообщения.Вставить("text", ТекстСообщения);
		ОписаниеСообщения.Вставить("emoji", "");
		Если НастройкиОтправкиОповещения.УстанавливатьОтправителемУведомленияАвтораСобытия Тогда
			ОписаниеСообщения.Вставить("alias", Строка(НастройкиОтправкиОповещения.Автор));
		КонецЕсли;

		ТекстЗапроса = СтрокаJSONИзОбъекта(ОписаниеСообщения);

		HTTPЗапрос = Новый HTTPЗапрос(URL, Заголовки);
		HTTPЗапрос.УстановитьТелоИзСтроки(ТекстЗапроса);
		ОтветHTTP = HTTP.ОтправитьДляОбработки(HTTPЗапрос);

	КонецЦикла;
КонецПроцедуры

Функция АдресПолучателя(Получатель) Экспорт
	КИ=УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Получатель, , , Ложь);

	Отбор=Новый Структура;
	Если ТипЗнч(Получатель) = Тип("СправочникСсылка.Пользователи") Тогда
		Отбор.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.АккаунтRocketChatПользователя);
	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.Партнеры") Тогда
		Отбор.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.АккаунтRocketChatПартнера);
	ИначеЕсли ТипЗнч(Получатель) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Отбор.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.АккаунтRocketChatФизическогоЛица);
	Иначе
		Возврат "";
	КонецЕсли;
	НайденныеСтроки=КИ.НайтиСтроки(Отбор);

	Адрес="";
	Для Каждого Стр Из НайденныеСтроки Цикл
		Если Не ЗначениеЗаполнено(Стр.Представление) Тогда
			Продолжить;
		КонецЕсли;

		Адрес=Стр.Представление;
		Прервать;
	КонецЦикла;

	Возврат Адрес;
КонецФункции

Функция ТекстИзмененийДляСообщения(Изменения) Экспорт
	ТекстИзменений="";

	Если Изменения.Количество() > 0 Тогда
//		ТекстИзменений="---" + Символы.ПС + Символы.ПС;
		Для Каждого ТекИзменение Из Изменения Цикл
			ТекстИзменений=ТекстИзменений + "- Параметр *" + ТекИзменение.Значение.Синоним + "* изменился с _"
				+ ТекИзменение.Значение.ПредыдущееЗначение + "_ на _" + ТекИзменение.Значение.Значение + "_"
				+ Символы.ПС;
		КонецЦикла;

	КонецЕсли;
	Возврат ТекстИзменений;
КонецФункции

Функция ТекстКомментарияПреобразованный(Инициатор, Знач КомментарийИзБазы, Сообщение) Экспорт
	Если Сообщение.ДополнительныеПараметры.ФорматКомментария=Перечисления.ВариантыОформленияТекста.Markdown Тогда
		Возврат КомментарийИзБазы;
	КонецЕсли;
	
	ТекстКомментария=КомментарийИзБазы;
	ТекстКомментария=ОповещенияПоЗадачам.ИзвлеченныйТекстИзHTML(ТекстКомментария);
	Возврат СокрЛП(ТекстКомментария);
КонецФункции

Функция СтрокаJSONИзОбъекта(Объект)
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	ЗаписатьJSON(Запись, Объект);
	Возврат Запись.Закрыть();

КонецФункции
Функция СтрокаJSONВОбъект(СтрокаJSON)
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(СтрокаJSON);
	ОтветJson = ПрочитатьJSON(Чтение);

	Чтение.Закрыть();

	Возврат ОтветJson;
КонецФункции