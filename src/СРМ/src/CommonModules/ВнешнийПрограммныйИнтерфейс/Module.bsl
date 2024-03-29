#Область ПрограммныйИнтерфейс

Функция ВнешнийПрограммныйИнтерфейсВключен() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Константы.ВнешнийПрограммныйИнтерфейсВключен.Получить();
КонецФункции

#Область Логирование

Функция УровеньЛогирования() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Уровень = Константы.УровеньЛогированияЗапросовКВнешнемуПрограммномуИнтерфейсу.Получить();
	Если Не ЗначениеЗаполнено(Уровень) Тогда
		Уровень=Перечисления.УровниЛогирования.Нет;
	КонецЕсли;
	
	Возврат Уровень;
КонецФункции

Функция НовыеПараметрыЛогаHTTPЗапроса(HTTPЗапрос) Экспорт
	
	ПараметрыЛога = Новый Структура;
	ПараметрыЛога.Вставить("НачалоЗапроса", ТекущаяДатаСеанса());
	ПараметрыЛога.Вставить("Идентификатор", Строка(Новый УникальныйИдентификатор));
	ПараметрыЛога.Вставить("ТелоЗапроса", HTTPЗапрос.ПолучитьТелоКакСтроку());
	ПараметрыЛога.Вставить("ИспользоватьHttps", Ложь);
	ПараметрыЛога.Вставить("ЗаголовкиЗапроса", ЗаголовкиЗапросаВСтроку(HTTPЗапрос.Заголовки));
	
	ПараметрыЛога.Вставить("Сервер", "");
	ПараметрыЛога.Вставить("Запрос", "");
	ПараметрыЛога.Вставить("HTTPФункция", "");

	Если ТипЗнч(HTTPЗапрос) = Тип("HTTPСервисЗапрос") Тогда
		ПараметрыЛога.Вставить("Сервер", HTTPЗапрос.БазовыйURL);
		ПараметрыЛога.Вставить("Запрос", HTTPЗапрос.ОтносительныйURL);
		ПараметрыЛога.Вставить("HTTPФункция", HTTPЗапрос.HTTPМетод);
	ИначеЕсли ТипЗнч(HTTPЗапрос) = Тип("HTTPЗапрос") Тогда
		ПараметрыЛога.Вставить("Сервер", "");
		ПараметрыЛога.Вставить("Запрос", HTTPЗапрос.АдресРесурса);
	КонецЕсли;
	
	ПараметрыЛога.Вставить("КодСостояния", 0);
	ПараметрыЛога.Вставить("ТелоОтвета", "");
	ПараметрыЛога.Вставить("ЗаголовкиОтвета", "");
	ПараметрыЛога.Вставить("Ошибка", Ложь);
	ПараметрыЛога.Вставить("КонецЗапроса", ТекущаяДатаСеанса());
	
	Возврат ПараметрыЛога;
	
КонецФункции

Функция ЗаголовкиЗапросаВСтроку(Заголовки) Экспорт
	
	СтрокаЗаголовков="";
	
	Для Каждого КлючЗначение Из Заголовки Цикл
		СтрокаЗаголовков=СтрокаЗаголовков+?(ЗначениеЗаполнено(СтрокаЗаголовков),Символы.ПС,"")+КлючЗначение.Ключ+":"+КлючЗначение.Значение;
	КонецЦикла;
	
	Возврат СтрокаЗаголовков;
	
КонецФункции

Процедура ЗафиксироватьЛогЗапроса(ЕстьОшибка, ПараметрыЛога, Ответ) Экспорт
	
	УровеньЛогирования = УровеньЛогирования();
	Если УровеньЛогирования = Перечисления.УровниЛогирования.Нет
		Или Не ЗначениеЗаполнено(УровеньЛогирования) Тогда
		Возврат;
	КонецЕсли;
	
	Если УровеньЛогирования = Перечисления.УровниЛогирования.Ошибки И Не ЕстьОшибка Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьЛога = РегистрыСведений.ЛогиЗапросовВнешнегоПрограммногоИнтерфейса.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(ЗаписьЛога, ПараметрыЛога);
	ЗаписьЛога.Ошибка = ЕстьОшибка;
	ЗаписьЛога.ЗаголовкиОтвета = ЗаголовкиЗапросаВСтроку(Ответ.Заголовки);
	ЗаписьЛога.ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
	ЗаписьЛога.КонецЗапроса = ТекущаяДатаСеанса();
	
	ЗаписьЛога.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОтветыСервиса

Функция ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога) Экспорт
	Возврат ОтветСервиса(Истина, "Программный интерфейс отключен", ПараметрыЛога);
КонецФункции

Функция ОтветСервиса(ЕстьОшибка, ДанныеОтвета, ПараметрыЛога) Экспорт
	//формирует запрос и возвращает ответ от Веб-сервиса
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
	
	Если ЕстьОшибка Тогда
		Ответ.КодСостояния=400;
	КонецЕсли;
	
	СтруктураОтвета=Новый Структура;
	СтруктураОтвета.Вставить("Статус",Не ЕстьОшибка);
	Если ЕстьОшибка Тогда
		СтруктураОтвета.Вставить("ТекстОшибки",ДанныеОтвета);
	Иначе
		СтруктураОтвета.Вставить("Данные",ДанныеОтвета);
	КонецЕсли;
	
	Ответ.УстановитьТелоИзСтроки(ОбщегоНазначенияКлиентСервер.ЗаписатьДанныеJSON(СтруктураОтвета));
	
	ЗафиксироватьЛогЗапроса(ЕстьОшибка, ПараметрыЛога, Ответ);
	Возврат Ответ;
	
КонецФункции

#КонецОбласти

Функция ОписаниеЗадачи(Задача)  Экспорт
	Описание = Новый Структура;
	Описание.Вставить("Тема", Задача.Тема);
	Описание.Вставить("Номер", Задача.Номер);
	Описание.Вставить("Дата", Задача.Дата);
	Описание.Вставить("ДатаСоздания", Задача.ДатаСоздания);
	Описание.Вставить("ДатаВыполнения", Задача.ДатаВыполнения);
	Описание.Вставить("ДатаЗакрытия", Задача.ДатаЗакрытия);
	Описание.Вставить("ДатаИзменения", Задача.ДатаИзменения);
	Описание.Вставить("ДатаНачалаРаботПоЗадаче", Задача.ДатаНачалаРаботПоЗадаче);
	Описание.Вставить("Проект", ОписаниеПроекта(Задача.Проект));
	Описание.Вставить("Автор", ОписаниеПользователя(Задача.Автор));
	Описание.Вставить("Исполнитель", ОписаниеПользователя(Задача.Исполнитель));
	Описание.Вставить("ОценкаТрудозатрат", Задача.ОценкаТрудозатрат);
	Описание.Вставить("ОценкаТрудозатратИсполнителя", Задача.ОценкаТрудозатратИсполнителя);
	Если ЗначениеЗаполнено(Задача.РодительскаяЗадача) Тогда
		Описание.Вставить("РодительскаяЗадача", Задача.РодительскаяЗадача.Номер);
	Иначе
		Описание.Вставить("РодительскаяЗадача", Неопределено);	
	КонецЕсли;
	Описание.Вставить("Содержание", Задача.Содержание);
	Описание.Вставить("СрокИсполнения", Задача.СрокИсполнения);
	Описание.Вставить("СрокИсполненияАвто", Задача.СрокИсполненияАвто);
	Описание.Вставить("СодержаниеФормат", ОбщегоНазначения.ИмяЗначенияПеречисления(Задача.СодержаниеФормат));
	Описание.Вставить("СодержаниеHTML", Задача.СодержаниеHTML);
	Описание.Вставить("Статус", ОписаниеСтатуса(Задача.Статус));
	Описание.Вставить("КатегорияЗакрытия", ОписаниеКатегорииЗадачи(Задача.КатегорияЗакрытия));
	Описание.Вставить("ВидОплаты", ОписаниеВидОплаты(Задача.ВидОплаты));
	Описание.Вставить("Трудозатраты", УправлениеЗадачами.ПолучитьТрудозатратыПоЗадаче(Задача.Ссылка));
	Описание.Вставить("Основание", ОписаниеОснованияКомментарияЗадачи(Задача.Основание));
	
	ПрисоединенныеФайлыСсылки= Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Задача.Ссылка, ПрисоединенныеФайлыСсылки);

	Файлы = Новый Массив;
	
	Для Каждого ТекСсылка Из ПрисоединенныеФайлыСсылки Цикл
		ДанныеФайла = Новый Структура;
		ДанныеФайла.Вставить("Идентификатор",				 Строка(ТекСсылка.УникальныйИдентификатор()));
		ДанныеФайла.Вставить("ДатаМодификацииУниверсальная", ТекСсылка.ДатаМодификацииУниверсальная);
		ДанныеФайла.Вставить("ИмяФайла",                     ТекСсылка.Наименование + "." + ТекСсылка.Расширение);
		ДанныеФайла.Вставить("Наименование",                 ТекСсылка.Наименование);
		ДанныеФайла.Вставить("Расширение",                   ТекСсылка.Расширение);
		ДанныеФайла.Вставить("Размер",                       ТекСсылка.Размер);
		ДанныеФайла.Вставить("ПометкаУдаления",              ТекСсылка.ПометкаУдаления);
		ДанныеФайла.Вставить("ДатаСоздания",              	ТекСсылка.ДатаСоздания);
		ДанныеФайла.Вставить("Автор",              			ОписаниеПользователя(ТекСсылка.Автор));
		
		Файлы.Добавить(ДанныеФайла);
	КонецЦикла;
	
	Описание.Вставить("ПрисоединенныеФайлы",Файлы);
	
	Описание.Вставить("Изменения", Новый Массив);
	
	ИзмененияЗадачи = УправлениеЗадачами.ИзмененияКлючевыхРеквизитовЗадачи(Задача);
	
	Для Каждого ТекИзменение Из ИзмененияЗадачи Цикл
		СтруктураИзмененияПоЗадаче=Новый Структура;
		СтруктураИзмененияПоЗадаче.Вставить("Дата", ТекИзменение.Дата);
		СтруктураИзмененияПоЗадаче.Вставить("Автор", ОписаниеПользователя(ТекИзменение.Автор));
		СтруктураИзмененияПоЗадаче.Вставить("ИзмененныеРеквизиты", ТекИзменение.Изменения);
		
		Описание.Изменения.Добавить(СтруктураИзмененияПоЗадаче);
	КонецЦикла;
	
	Описание.Вставить("Комментарии", Новый Массив);
	
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	КомментарииЗадач.Задача КАК Задача,
	|	КомментарииЗадач.ТекстСообщения КАК ТекстСообщения,
	|	КомментарииЗадач.ДатаСоздания КАК ДатаСоздания,
	|	КомментарииЗадач.Ссылка КАК Ссылка,
	|	КомментарииЗадач.Автор КАК Автор,
	|	КомментарииЗадач.Основание КАК Основание,
	|	КомментарииЗадач.ТекстСообщенияФормат КАК Формат,
	|	КомментарииЗадач.ОтправитьСообщениеКонтакту КАК ОтправитьСообщениеКонтакту,
	|	КомментарииЗадач.ДополнительныеПолучателиОповещения.(
	|		Адрес КАК Адрес,
	|		Представление КАК Представление,
	|		ВариантОтправки КАК ВариантОтправки
	|	) КАК ДополнительныеПолучателиОповещения
	|ИЗ
	|	Справочник.КомментарииЗадач КАК КомментарииЗадач
	|ГДЕ
	|	КомментарииЗадач.Задача = &Задача
	|
	|УПОРЯДОЧИТЬ ПО
	|	КомментарииЗадач.ДатаСоздания";
	
	Запрос.УстановитьПараметр("Задача", Задача);

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовыйКомментарий = Новый Структура;
		НовыйКомментарий.Вставить("Идентификатор",Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		НовыйКомментарий.Вставить("ДатаСоздания",Выборка.ДатаСоздания);
		НовыйКомментарий.Вставить("Формат",ОбщегоНазначения.ИмяЗначенияПеречисления(Выборка.Формат));
		НовыйКомментарий.Вставить("ТекстСообщения",Выборка.ТекстСообщения);
		НовыйКомментарий.Вставить("Автор",ОписаниеПользователя(Выборка.Автор));
		НовыйКомментарий.Вставить("Основание", ОписаниеОснованияКомментарияЗадачи(Выборка.Основание));
		
		НовыйКомментарий.Вставить("ОтправитьСообщениеКонтакту",Выборка.ОтправитьСообщениеКонтакту);
		НовыйКомментарий.Вставить("ДополнительныеПолучателиОповещения", Новый Массив);
		ВыборкаПолучателей = Выборка.ДополнительныеПолучателиОповещения.Выбрать();
		Пока ВыборкаПолучателей.Следующий() Цикл
			ТекПолучатель = Новый Структура;
			ТекПолучатель.Вставить("Адрес", ВыборкаПолучателей.Адрес);
			ТекПолучатель.Вставить("Представление", ВыборкаПолучателей.Представление);
			ТекПолучатель.Вставить("ВариантОтправки", ВыборкаПолучателей.ВариантОтправки);
			
			НовыйКомментарий.ДополнительныеПолучателиОповещения.Добавить(ТекПолучатель);
		КонецЦикла;
		
		НовыйКомментарий.Вставить("ПрисоединенныеФайлы", Новый Массив);
		
		Для Каждого ТекФайл Из ПрисоединенныеФайлыСсылки Цикл
			Если ТекФайл.Предмет <> Выборка.Ссылка Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйКомментарий.ПрисоединенныеФайлы.Добавить(Строка(ТекФайл.УникальныйИдентификатор()));
		КонецЦикла;
		
		Описание.Комментарии.Добавить(НовыйКомментарий);
	КонецЦикла;

	
	Возврат Описание;
КонецФункции

Функция ОписаниеОснованияКомментарияЗадачи(Основание)
	Если Не ЗначениеЗаполнено(Основание) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Основание) <> Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Описание=Новый Структура;
	Описание.Вставить("Идентификатор", Строка(Основание.УникальныйИдентификатор()));
	Описание.Вставить("Дата", Основание.Дата);
	Описание.Вставить("Отправитель", Новый Структура);
	Если ЗначениеЗаполнено(Основание.ОтправительКонтакт) Тогда
		Описание.Отправитель.Вставить("Наименование", Строка(Основание.ОтправительКонтакт));
	Иначе
		Описание.Отправитель.Вставить("Наименование", Основание.ОтправительПредставление);
	КонецЕсли;
	Описание.Отправитель.Вставить("Адрес", Основание.ОтправительАдрес);
	
	Описание.Вставить("Копии", Новый Массив);
	
	МассивТЧ = Новый Массив;
	МассивТЧ.Добавить("ПолучателиПисьма");
	МассивТЧ.Добавить("ПолучателиКопий");
	МассивТЧ.Добавить("ПолучателиОтвета");
	
	Для Каждого ТекИмяТЧ Из МассивТЧ Цикл
		Для Каждого СтрокаПолучателя Из Основание[ТекИмяТЧ] Цикл
			Если НРег(СтрокаПолучателя.Адрес) = НРег(Основание.УчетнаяЗапись.АдресЭлектроннойПочты) Тогда
				Продолжить;
			КонецЕсли;
			Получатель = Новый Структура;
			Если ЗначениеЗаполнено(СтрокаПолучателя.Контакт) Тогда
				Получатель.Вставить("Наименование", Строка(СтрокаПолучателя.Контакт));
			Иначе
				Получатель.Вставить("Наименование", СтрокаПолучателя.Представление);
			КонецЕсли;
			Получатель.Вставить("Адрес", СтрокаПолучателя.Адрес);
			
			Получатель.Вставить("СкрытаяКопия", ТекИмяТЧ ="ПолучателиКопий");
			
			Описание.Копии.Добавить(Получатель);
		КонецЦикла;
	КонецЦикла;
	
	
	Возврат Описание;
КонецФункции

Функция ОписаниеПользователя(Пользователь) Экспорт
	НовыйПользователь = Новый Структура;
	НовыйПользователь.Вставить("Идентификатор", Строка(Пользователь.Ссылка.УникальныйИдентификатор()));
	НовыйПользователь.Вставить("Наименование", Пользователь.Наименование);
	
	Возврат НовыйПользователь;	
КонецФункции

Функция ОписаниеВидаПроекта(ВидПроекта) Экспорт 
	Если Не ЗначениеЗаполнено(ВидПроекта) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Описание = Новый Структура;
	Описание.Вставить("Идентификатор", Строка(ВидПроекта.УникальныйИдентификатор()));
	Описание.Вставить("Наименование", Строка(ВидПроекта));
	
	Возврат Описание;
КонецФункции

Функция ОписаниеПартнера(Партнер) Экспорт 
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Описание = Новый Структура;
	Описание.Вставить("Идентификатор", Строка(Партнер.УникальныйИдентификатор()));
	Описание.Вставить("Наименование", Строка(Партнер));
	
	Возврат Описание;
КонецФункции

Функция ОписаниеПроекта(Проект) Экспорт
	Если не ЗначениеЗаполнено(Проект) Тогда
		Возврат Неопределено;
	КонецЕсли;
	НовыйЭлемент = Новый Структура;
	НовыйЭлемент.Вставить("Идентификатор", Строка(Проект.Ссылка.УникальныйИдентификатор()));
	НовыйЭлемент.Вставить("Наименование", Проект.Наименование);
	Если ЗначениеЗаполнено(Проект.Родитель) Тогда
		НовыйЭлемент.Вставить("Родитель", Строка(Проект.Родитель.УникальныйИдентификатор()));
	Иначе
		НовыйЭлемент.Вставить("Родитель", Неопределено);
	КонецЕсли;
	НовыйЭлемент.Вставить("Архивный", Проект.Архивный);
	НовыйЭлемент.Вставить("Описание", Проект.Описание);
	НовыйЭлемент.Вставить("Вид", ОписаниеВидаПроекта(Проект.Вид));
	НовыйЭлемент.Вставить("Партнер", ОписаниеПартнера(Проект.Партнер));
	Возврат НовыйЭлемент;	
КонецФункции

Функция ОписаниеСтатуса(Статус) Экспорт
	Если не ЗначениеЗаполнено(Статус) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Описание = Новый Структура;
	Описание.Вставить("Идентификатор", Строка(Статус.Ссылка.УникальныйИдентификатор()));
	Описание.Вставить("Наименование", Статус.Наименование);
	Описание.Вставить("Вид", ОбщегоНазначения.ИмяЗначенияПеречисления(Статус.Вид));
	
	Возврат Описание;
КонецФункции

Функция ОписаниеКатегорииЗадачи(Категория) Экспорт
	Если не ЗначениеЗаполнено(Категория) Тогда
		Возврат Неопределено;
	КонецЕсли;
	НовыйЭлемент = Новый Структура;
	НовыйЭлемент.Вставить("Идентификатор", Строка(Категория.Ссылка.УникальныйИдентификатор()));
	НовыйЭлемент.Вставить("Наименование", Категория.Наименование);
	Если ЗначениеЗаполнено(Категория.Родитель) Тогда
		НовыйЭлемент.Вставить("Родитель", Строка(Категория.Родитель.УникальныйИдентификатор()));
	Иначе
		НовыйЭлемент.Вставить("Родитель", Неопределено);
	КонецЕсли;
	
	Возврат НовыйЭлемент;	
КонецФункции

Функция ОписаниеВидОплаты(ВидОплаты) Экспорт
	Если не ЗначениеЗаполнено(ВидОплаты) Тогда
		Возврат Неопределено;
	КонецЕсли;
	НовыйЭлемент = Новый Структура;
	НовыйЭлемент.Вставить("Идентификатор", Строка(ВидОплаты.Ссылка.УникальныйИдентификатор()));
	НовыйЭлемент.Вставить("Наименование", ВидОплаты.Наименование);
	Возврат НовыйЭлемент;	
КонецФункции



#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// предназначен для модулей, которые являются частью некоторой функциональной подсистемы. В нем должны быть размещены экспортные процедуры и функции, которые допустимо вызывать только из других функциональных подсистем этой же библиотеки.
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// содержит процедуры и функции, составляющие внутреннюю реализацию общего модуля. В тех случаях, когда общий модуль является частью некоторой функциональной подсистемы, включающей в себя несколько объектов метаданных, в этом разделе также могут быть размещены служебные экспортные процедуры и функции, предназначенные только для вызова из других объектов данной подсистемы.
#КонецОбласти