#Область ПрограммныйИнтерфейс

// Определяет состав назначений и общие реквизиты в шаблонах сообщений 
//
// Параметры:
//  Настройки - Структура - Структура с ключами:
//    * ПредметыШаблонов - ТаблицаЗначений - Содержит варианты предметов для шаблонов. Колонки:
//         ** Имя           - Строка - Уникальное имя назначения.
//         ** Представление - Строка - Представление варианта.
//         ** Макет         - Строка - Имя макета СКД, если состав реквизитов определяется посредством СКД.
//         ** ЗначенияПараметровСКД - Структура - Значения параметров СКД для текущего предмета шаблона сообщения.
//    * ОбщиеРеквизиты - ТаблицаЗначений - Содержит описание общих реквизитов доступных во всех шаблонах. Колонки:
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип общего реквизита. По умолчанию строка.
//    * ИспользоватьПроизвольныеПараметры  - Булево - указывает, можно ли использовать произвольные пользовательские
//                                                    параметры в шаблонах сообщений.
//    * ЗначенияПараметровСКД - Структура - Общие значения параметров СКД, для всех макетов, где состав реквизитов
//                                          определяется средствами СКД.
//
Процедура ПриОпределенииНастроекШаблоновСообщений(Настройки) Экспорт

	Предмет = Настройки.ПредметыШаблонов.Добавить();
	Предмет.Имя = "ОповещениеОбИзмененииЗадачиДляКонтакта";
	Предмет.Представление = НСтр("ru = 'Оповещение об изменении задачи для контакта'");

	Настройки.ИспользоватьПроизвольныеПараметры=Истина;
	Настройки.РасширенныйСписокПолучателей=Истина;
	Настройки.ФорматПисьма="HTML";

КонецПроцедуры

// Вызывается при подготовке шаблонов сообщений и позволяет переопределить список реквизитов и вложений.
//
// Параметры:
//  Реквизиты               - ДеревоЗначений - список реквизитов шаблона.
//         ** Имя            - Строка - Уникальное имя общего реквизита.
//         ** Представление  - Строка - Представление общего реквизита.
//         ** Тип            - Тип    - Тип реквизита. По умолчанию строка.
//         ** Подсказка      - Строка - Расширенная информация о реквизите.
//         ** Формат         - Строка - Формат вывода значения для чисел, дат, строк и булевых значений.
//  Вложения                - ТаблицаЗначений - печатные формы и вложения
//         ** Имя            - Строка - Уникальное имя вложения.
//         ** Представление  - Строка - Представление варианта.
//         ** Подсказка      - Строка - Расширенная информация о вложении.
//         ** ТипФайла       - Строка - Тип вложения, который соответствует расширению файла: "pdf", "png", "jpg", mxl"
//                                      и др.
//  НазначениеШаблона       - Строка  - Имя назначения шаблон сообщения.
//  ДополнительныеПараметры - Структура - дополнительные сведения о шаблоне сообщения.
//
Процедура ПриПодготовкеШаблонаСообщения(Реквизиты, Вложения, НазначениеШаблона, ДополнительныеПараметры) Экспорт
	Если НазначениеШаблона = "ОповещениеОбИзмененииЗадачиДляКонтакта" Тогда

		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "Задача";
		НовыйРеквизит.Представление = НСтр("ru = 'Задача'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("ДокументСсылка.Задача");
		
		//подчиненные реквизиты
		Для Каждого Реквизит Из Метаданные.Документы.Задача.Реквизиты Цикл
			НовыйР = НовыйРеквизит.Строки.Добавить();
			НовыйР.Имя = НазначениеШаблона + ".Задача." + Реквизит.Имя;
			НовыйР.Представление = Реквизит.Синоним;
			НовыйР.Тип = Реквизит.Тип;
		КонецЦикла;

		НовыйР = НовыйРеквизит.Строки.Добавить();
		НовыйР.Имя = НазначениеШаблона + ".Задача." + Метаданные.Документы.Задача.СтандартныеРеквизиты.Номер.Имя;
		НовыйР.Представление = Метаданные.Документы.Задача.СтандартныеРеквизиты.Номер.Имя;
		НовыйР.Тип = Реквизит.Тип;

		НовыйР = НовыйРеквизит.Строки.Добавить();
		НовыйР.Имя = НазначениеШаблона + ".Задача." + Метаданные.Документы.Задача.СтандартныеРеквизиты.Дата.Имя;
		НовыйР.Представление = Метаданные.Документы.Задача.СтандартныеРеквизиты.Дата.Имя;
		НовыйР.Тип = Реквизит.Тип;

		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "Автор";
		НовыйРеквизит.Представление = НСтр("ru = 'Автор'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("СправочникСсылка.Пользователи");

		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "ТекстКомментария";
		НовыйРеквизит.Представление = НСтр("ru = 'Текст комментария'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("Строка");

		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "Изменения";
		НовыйРеквизит.Представление = НСтр("ru = 'Изменения задачи'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("Строка");
	КонецЕсли;

КонецПроцедуры

// Вызывается в момент создания сообщений по шаблону для заполнения значений реквизитов и вложений.
//
// Параметры:
//  Сообщение - Структура - структура с ключами:
//    * ЗначенияРеквизитов - Соответствие - список используемых в шаблоне реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * ЗначенияОбщихРеквизитов - Соответствие - список используемых в шаблоне общих реквизитов.
//      ** Ключ     - Строка - имя реквизита в шаблоне;
//      ** Значение - Строка - значение заполнения в шаблоне.
//    * Вложения - Соответствие - значения реквизитов 
//      ** Ключ     - Строка - имя вложения в шаблоне;
//      ** Значение - ДвоичныеДанные, Строка - двоичные данные или адрес во временном хранилище вложения.
//    * ДополнительныеПараметры - Структура - Дополнительные параметры сообщения. 
//  НазначениеШаблона - Строка -  полное имя назначения шаблон сообщения.
//  ПредметСообщения - ЛюбаяСсылка - ссылка на объект являющийся источником данных.
//  ПараметрыШаблона - Структура -  Дополнительная информация о шаблоне сообщения.
//
Процедура ПриФормированииСообщения(Сообщение, НазначениеШаблона, ПредметСообщения, ПараметрыШаблона) Экспорт

	Если НазначениеШаблона = "ОповещениеОбИзмененииЗадачиДляКонтакта" Тогда
		Сообщение.ЗначенияРеквизитов["Автор"]=Сообщение.ДополнительныеПараметры.Автор;

		Сообщение.ЗначенияРеквизитов["ТекстКомментария"]="<hr>"
			+ Сообщение.ДополнительныеПараметры.Комментарий;

		ТекстИзменений="";

		Если Сообщение.ДополнительныеПараметры.Изменения.Количество() > 0 Тогда
			ТекстИзменений="<hr>"
				+ Символы.ПС + "<ul>" + Символы.ПС;
			Для Каждого ТекИзменение Из Сообщение.ДополнительныеПараметры.Изменения Цикл
				ТекстИзменений=ТекстИзменений + "<li>Параметр <strong>" + ТекИзменение.Ключ
					+ "</strong> изменился с <i>" + ТекИзменение.Значение.ПредыдущееЗначение + "</i> на <i>"
					+ ТекИзменение.Значение.Значение + "</i></li>" + Символы.ПС;
			КонецЦикла;

			ТекстИзменений=ТекстИзменений + "</ul>";

		КонецЕсли;

		Сообщение.ЗначенияРеквизитов["Изменения"]=ТекстИзменений;

		Задача=Сообщение.ДополнительныеПараметры.Задача;

		ПараметрыЗадача=Сообщение.ЗначенияРеквизитов["Задача"];
		Если ТипЗнч(ПараметрыЗадача) = Тип("Соответствие") Тогда
			Для Каждого КлючЗначение Из ПараметрыЗадача Цикл
				ПараметрыЗадача[КлючЗначение.Ключ]=Задача[КлючЗначение.Ключ];
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Заполняет список получателей почты при отправки сообщения сформированного по шаблону.
//
// Параметры:
//   ПолучателиПисьма - ТаблицаЗначений - список получается письма.
//     * Адрес           - Строка - адрес электронной почты получателя.
//     * Представление   - Строка - представление получателя письма.
//     * Контакт         - Произвольный - контакт, которому принадлежит адрес электронной почты.
//  НазначениеШаблона - Строка - идентификатор назначения шаблона.
//  ПредметСообщения - ЛюбаяСсылка, Структура - ссылка на объект, являющийся источником данных, либо структура,
//                                              если шаблон содержит произвольные параметры:
//    * Предмет               - ЛюбаяСсылка - ссылка на объект, являющийся источником данных;
//    * ПроизвольныеПараметры - Соответствие - заполненный список произвольных параметров.
//
Процедура ПриЗаполненииПочтыПолучателейВСообщении(ПолучателиПисьма, НазначениеШаблона, ПредметСообщения) Экспорт
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередЗаписьюОбъектаФормированиеДанныхДляОповещений(Источник, Отказ) Экспорт
	ДанныеТранзакцииОповещений=НовыйДанныеТранзакцииОповещенияОбъекта();
	ДанныеТранзакцииОповещений.ЭтоНовый=Источник.ЭтоНовый();
	ДанныеТранзакцииОповещений.Изменения=ИзмененияОбъектаПередЗаписью(Источник);
	ДанныеТранзакцииОповещений.ЭтоЗадача=ТипЗнч(Источник) = Тип("ДокументОбъект.Задача");
	ЗаполнитьСобытияЗаписиОбъекта(Источник, ДанныеТранзакцииОповещений);

	Если ТипЗнч(Источник) = Тип("ДокументОбъект.Задача") Тогда
		ДанныеТранзакцииОповещений.Задача=Источник.Ссылка;
	Иначе
		ДанныеТранзакцииОповещений.Задача=Источник.Задача;
	КонецЕсли;

	ДанныеТранзакцииОповещений.Проект=ДанныеТранзакцииОповещений.Задача.Проект;
	ДанныеТранзакцииОповещений.Партнер=ДанныеТранзакцииОповещений.Проект.Партнер;

	Источник.ДополнительныеСвойства.Вставить("ДанныеТранзакцииОповещений", ДанныеТранзакцииОповещений);
КонецПроцедуры

Процедура ПриЗаписиОбъектаФормированиеДанныхОповещений(Источник, Отказ) Экспорт
	ДанныеТранзакцииОповещений=Источник.ДополнительныеСвойства.ДанныеТранзакцииОповещений;
	ДанныеТранзакцииОповещений.Инициатор=Источник.Ссылка;
	Если ЗначениеЗаполнено(ДанныеТранзакцииОповещений.Проект.НастройкаОповещенияПоЗадачам) Тогда
		НастройкаОповещения=ДанныеТранзакцииОповещений.Проект.НастройкаОповещенияПоЗадачам;
	ИначеЕсли ЗначениеЗаполнено(ДанныеТранзакцииОповещений.Партнер.НастройкаОповещенияПоЗадачам) Тогда
		НастройкаОповещения=ДанныеТранзакцииОповещений.Партнер.НастройкаОповещенияПоЗадачам;
	Иначе
		НастройкаОповещения=Справочники.НастройкиОповещенийПоЗадачам.ПоУмолчанию;
	КонецЕсли;

	НаборВсеСобытия=Справочники.НаборыСобытийОповещений.ВсеСобытия;

	Для Каждого СтрокаТЧ Из НастройкаОповещения.НастройкиТранспорта Цикл
		Для Каждого Событие Из ДанныеТранзакцииОповещений.События Цикл
			СобытиеВходитВНабор=СтрокаТЧ.НаборСобытий = НаборВсеСобытия Или СтрокаТЧ.НаборСобытий.События.Найти(
				Событие, "Событие");

			Если СобытиеВходитВНабор Тогда
				ЗарегистрироватьОповещениеКОтправке(ДанныеТранзакцииОповещений.Задача, Событие, Источник.Ссылка,
					ДанныеТранзакцииОповещений, СтрокаТЧ.ШаблонСообщения, СтрокаТЧ.УчетнаяЗаписьОповещений);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	ЗапуститьОтправкуОповещенийПоТранзакции(ДанныеТранзакцииОповещений);
КонецПроцедуры

Процедура ЗапуститьОтправкуОповещенийПоТранзакции(ДанныеТранзакцииОповещений)
	ПараметрыПроцедуры=Новый Структура;
	ПараметрыПроцедуры.Вставить("Транзакция", ДанныеТранзакцииОповещений);
	ПараметрыВыполнения=ДлительныеОперации.ПараметрыВыполненияВФоне(Неопределено);
	ПараметрыВыполнения.ЗапуститьВФоне=Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания="Отправка оповещений по задаче " + ДанныеТранзакцииОповещений.Задача;
	ОтправитьОповещенияПоТранзакцииОповещений(ПараметрыПроцедуры, Неопределено);
	
//	ДлительныеОперации.ВыполнитьВФоне("ОповещенияПоЗадачам.ОтправитьОповещенияПоТранзакцииОповещений",
//		ПараметрыПроцедуры, ПараметрыВыполнения);

КонецПроцедуры

Процедура ОтправитьОповещенияПоТранзакцииОповещений(ПараметрыПроцедуры, АдресРезультата) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Транзакция=ПараметрыПроцедуры.Транзакция;

	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ОповещенияПоЗадачамКОтправке.Идентификатор,
	|	ОповещенияПоЗадачамКОтправке.Событие,
	|	ОповещенияПоЗадачамКОтправке.ИнициаторСобытия,
	|	ОповещенияПоЗадачамКОтправке.ДатаОтправки
	|ИЗ
	|	РегистрСведений.ОповещенияПоЗадачамКОтправке КАК ОповещенияПоЗадачамКОтправке
	|ГДЕ
	|	ОповещенияПоЗадачамКОтправке.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", Транзакция.Идентификатор);

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ДатаОтправки) Тогда
			Продолжить;
		КонецЕсли;
		ОтправитьОповещение(Выборка.Идентификатор, Выборка.Событие, Выборка.ИнициаторСобытия);
	КонецЦикла;
КонецПроцедуры

Процедура ОтправитьОповещение(Идентификатор, Событие, ИнициаторСобытия) Экспорт

	МенеджерЗаписи=РегистрыСведений.ОповещенияПоЗадачамКОтправке.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор=Идентификатор;
	МенеджерЗаписи.Событие=Событие;
	МенеджерЗаписи.ИнициаторСобытия=ИнициаторСобытия;
	МенеджерЗаписи.Прочитать();

	Если Не МенеджерЗаписи.Выбран() Тогда
		Возврат;
	КонецЕсли;

	ДатаОтправки=Неопределено;
	Ошибка="";

	ДанныеСобытия=МенеджерЗаписи.ДанныеСобытия.Получить();
	ДанныеСобытия.Вставить("Автор", МенеджерЗаписи.Автор);
	ДанныеСобытия.Вставить("Дата", МенеджерЗаписи.Дата);
	ДанныеСобытия.Вставить("Задача", МенеджерЗаписи.Задача);
	ДанныеСобытия.Вставить("УчетнаяЗаписьОповещения", МенеджерЗаписи.УчетнаяЗапись);
	Если ТипЗнч(ИнициаторСобытия) = Тип("СправочникСсылка.КомментарииЗадач") Тогда
		ДанныеСобытия.Вставить("Комментарий", ИнициаторСобытия.ТекстСообщения);
	Иначе
		ДанныеСобытия.Вставить("Комментарий", "");
	КонецЕсли;

	ПараметрыШаблона=ШаблоныСообщений.ПараметрыШаблона(МенеджерЗаписи.ШаблонСообщения);

	Сообщение = ШаблоныСообщений.СформироватьСообщение(МенеджерЗаписи.ШаблонСообщения, ДанныеСобытия.Задача,
		Новый УникальныйИдентификатор, ДанныеСобытия);
	МодульКаналаОповещения=МодульКаналаОповещенияПоУчетнойЗаписи(МенеджерЗаписи.УчетнаяЗапись);

	ЗаполнитьПолучателейСообщенияОповещения(Сообщение, ДанныеСобытия);

	Если МодульКаналаОповещения = Неопределено Тогда
		Ошибка="Выбранный канал оповещения не поддерживается";
	Иначе
		МодульКаналаОповещения.ВыполнитьОтправкуСообщения(Сообщение, МенеджерЗаписи.УчетнаяЗапись, Ошибка);
		Если Не ЗначениеЗаполнено(Ошибка) Тогда
			ДатаОтправки=ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЕсли;

	МенеджерЗаписи.КоличествоПопыток=МенеджерЗаписи.КоличествоПопыток + 1;
	МенеджерЗаписи.Ошибка=Ошибка;
	МенеджерЗаписи.ДатаОтправки=ДатаОтправки;
	МенеджерЗаписи.Записать(Истина);
КонецПроцедуры

Процедура ОтправитьОповещенияНеотправленныеПриЗаписи() Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПотенциальногоПолучателя(ПотенциальныеПолучатели, Получатель, ПредметСообщения) Экспорт
	Если Не ЗначениеЗаполнено(Получатель) Тогда
		Возврат;
	КонецЕсли;

	Если Получатель = ПредметСообщения.Автор Тогда
		Возврат;
	КонецЕсли;

	ПотенциальныеПолучатели.Добавить(Получатель);
КонецПроцедуры

Процедура ЗаполнитьПолучателейСообщенияОповещения(Сообщение, ДанныеСобытия)
	МодульКаналаОповещения=МодульКаналаОповещенияПоУчетнойЗаписи(ДанныеСобытия.УчетнаяЗаписьОповещения);

	Задача=ДанныеСобытия.Задача;

	МассивПотенциальныхПолучателей=Новый Массив;
	ДобавитьПотенциальногоПолучателя(МассивПотенциальныхПолучателей, Задача.Автор, ДанныеСобытия);
	ДобавитьПотенциальногоПолучателя(МассивПотенциальныхПолучателей, Задача.Исполнитель, ДанныеСобытия);
//	ДобавитьПотенциальногоПолучателя(МассивПотенциальныхПолучателей, Задача.КонтактОбращения, ПредметСообщения);
	// Наблюдатели

	Для Каждого Получатель Из МассивПотенциальныхПолучателей Цикл
		Адрес=МодульКаналаОповещения.АдресПолучателя(Получатель);
		Если Не ЗначениеЗаполнено(Адрес) Тогда
			Продолжить;
		КонецЕсли;

		ПолучательСообщения = Новый Структура;
		ПолучательСообщения.Вставить("Представление", Строка(Получатель));
		ПолучательСообщения.Вставить("Адрес", МодульКаналаОповещения.АдресПолучателя(Получатель));
		ПолучательСообщения.Вставить("ИсточникКонтактнойИнформации", Получатель);
		Сообщение.Получатель.Добавить(ПолучательСообщения);
	КонецЦикла;

КонецПроцедуры

Функция МодульКаналаОповещенияПоУчетнойЗаписи(УчетнаяЗапись)
	Канал=УчетнаяЗапись.Канал;
	Если Канал = Перечисления.КаналыОповещений.Email Тогда
		Возврат ОбщегоНазначения.ОбщийМодуль("ОповещенияПоЗадачамКаналЭлектроннаяПочта");
	ИначеЕсли Канал = Перечисления.КаналыОповещений.RocketChat Тогда
		Возврат ОбщегоНазначения.ОбщийМодуль("ОповещенияПоЗадачамКаналRocketChat");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция НовыйДанныеТранзакцииОповещенияОбъекта() Экспорт
	Данные=Новый Структура;
	Данные.Вставить("Идентификатор", Новый УникальныйИдентификатор);
	Данные.Вставить("ЭтоНовый", Ложь);
	Данные.Вставить("Изменения", Новый Структура);
	Данные.Вставить("Метаданные", Неопределено);
	Данные.Вставить("ЭтоЗадача", Ложь);
	Данные.Вставить("События", Новый Массив);
	Данные.Вставить("Инициатор", Неопределено);
	Данные.Вставить("Задача", Документы.Задача.ПустаяСсылка());
	Данные.Вставить("Проект", Справочники.Проекты.ПустаяСсылка());
	Данные.Вставить("Партнер", Справочники.Партнеры.ПустаяСсылка());

	Возврат Данные;
КонецФункции

Процедура ЗарегистрироватьОповещениеКОтправке(Задача, Событие, ИнициаторСобытия, ДанныеСобытия, ШаблонСообщения,
	УчетнаяЗапись) Экспорт
	НовоеОповещение=РегистрыСведений.ОповещенияПоЗадачамКОтправке.СоздатьМенеджерЗаписи();
	НовоеОповещение.Событие=Событие;
	НовоеОповещение.Идентификатор=ДанныеСобытия.Идентификатор;
	НовоеОповещение.ИнициаторСобытия=ИнициаторСобытия;

	НовоеОповещение.Задача=Задача;
	НовоеОповещение.Автор=Пользователи.ТекущийПользователь();
	НовоеОповещение.Дата=ТекущаяДатаСеанса();
	НовоеОповещение.ШаблонСообщения=ШаблонСообщения;
	НовоеОповещение.УчетнаяЗапись=УчетнаяЗапись;
	НовоеОповещение.ДанныеСобытия=Новый ХранилищеЗначения(ДанныеСобытия, Новый СжатиеДанных(9));
	НовоеОповещение.Записать(Истина);
КонецПроцедуры

Функция ИзмененияОбъектаПередЗаписью(Источник)
	Если Источник.ЭтоНовый() Тогда
		Возврат Новый Структура;
	КонецЕсли;

	Метаданныеобъекта=Источник.Метаданные();
	ПредыдущийОбъект=Источник.Ссылка.ПолучитьОбъект();

	СтруктураИзменений=Новый Структура;

	Для Каждого Реквизит Из Метаданныеобъекта.Реквизиты Цикл
		Если Источник[Реквизит.Имя] <> ПредыдущийОбъект[Реквизит.Имя] Тогда
			СтруктураИзменений.Вставить(Реквизит.Имя, Новый Структура("ПредыдущееЗначение, Значение",
				ПредыдущийОбъект[Реквизит.Имя], Источник[Реквизит.Имя]));
		КонецЕсли;
	КонецЦикла;

	Возврат СтруктураИзменений;
КонецФункции

Процедура ЗаполнитьСобытияЗаписиОбъекта(Источник, ДанныеТранзакцииОповещений)
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.Задача") Тогда
		Если ДанныеТранзакцииОповещений.ЭтоНовый Тогда
			ДанныеТранзакцииОповещений.События.Добавить(Перечисления.СобытияОповещений.НоваяЗадача);
		Иначе
			ЕстьИзменениеКлючевогоРеквизита=Ложь;
			КлючевыеРеквизиты=КлючевыеРеквизитыЗадачи();
			Для Каждого КлючЗначение Из ДанныеТранзакцииОповещений.Изменения Цикл
				Если КлючевыеРеквизиты.Найти(КлючЗначение.Ключ) <> Неопределено Тогда
					ЕстьИзменениеКлючевогоРеквизита=Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			Если ЕстьИзменениеКлючевогоРеквизита Тогда
				ДанныеТранзакцииОповещений.События.Добавить(Перечисления.СобытияОповещений.ИзмененаЗадача);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипЗнч(Источник) = Тип("СправочникОбъект.КомментарииЗадач") Тогда
		Если ДанныеТранзакцииОповещений.ЭтоНовый Тогда
			ДанныеТранзакцииОповещений.События.Добавить(Перечисления.СобытияОповещений.НовыйКомментарийЗадачи);
//		Иначе
//			ДопСвойства.События.Добавить(Перечисления.СобытияОповещений.и);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция КлючевыеРеквизитыЗадачи()
	Массив=Новый Массив;
	Массив.Добавить("ДатаВыполнения");
	Массив.Добавить("ДатаЗакрытия");
	Массив.Добавить("ДатаНачалаРаботПоЗадаче");
	Массив.Добавить("Исполнитель");
	Массив.Добавить("ОценкаТрудозатрат");
	Массив.Добавить("Проект");
	Массив.Добавить("РодительскаяЗадача");
	Массив.Добавить("Спринт");
	Массив.Добавить("Срочность");
	Массив.Добавить("Тема");
	Массив.Добавить("Статус");
	Массив.Добавить("СрокИсполнения");

	Возврат Массив;
КонецФункции

#КонецОбласти