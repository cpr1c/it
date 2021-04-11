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

		НовыйР = Реквизиты.Добавить();
		НовыйР.Имя = "ВнешняяHTTPСсылкаНаЗадачу";
		НовыйР.Представление = "Внешняя HTTP ссылка на задачу";
		НовыйР.Тип = Новый ОписаниеТипов("Строка");

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

		НовыйРеквизит = Реквизиты.Добавить();
		НовыйРеквизит.Имя = "СобытиеОповещения";
		НовыйРеквизит.Представление = НСтр("ru = 'Событие оповещения'");
		НовыйРеквизит.Тип = Новый ОписаниеТипов("ПеречислениеСсылка.СобытияОповещений");
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
		АдресВИнтернете=Константы.АдресПубликацииИнформационнойБазыВИнтернете.Получить();
		Если ЗначениеЗаполнено(АдресВИнтернете) Тогда
			АдресВИнтернете=АдресВИнтернете + "#" + ПолучитьНавигационнуюСсылку(
				Сообщение.ДополнительныеПараметры.Задача);
		КонецЕсли;

		Сообщение.ЗначенияРеквизитов["ВнешняяHTTPСсылкаНаЗадачу"]=АдресВИнтернете;
		Сообщение.ЗначенияРеквизитов["Автор"]=Сообщение.ДополнительныеПараметры.Автор;
		Сообщение.ЗначенияРеквизитов["СобытиеОповещения"]=Сообщение.ДополнительныеПараметры.СобытиеОповещения;
		МодульКаналаОповещения=МодульКаналаОповещенияПоУчетнойЗаписи(
			Сообщение.ДополнительныеПараметры.УчетнаяЗаписьОповещения);
		ТекстИзменений=МодульКаналаОповещения.ТекстИзмененийДляСообщения(
			Сообщение.ДополнительныеПараметры.ИзмененияКлючевыхРеквизитов);

		Сообщение.ЗначенияРеквизитов["Изменения"]=ТекстИзменений;

		Задача=Сообщение.ДополнительныеПараметры.Задача;

		ПараметрыЗадача=Сообщение.ЗначенияРеквизитов["Задача"];
		Если ТипЗнч(ПараметрыЗадача) = Тип("Соответствие") Тогда
			Для Каждого КлючЗначение Из ПараметрыЗадача Цикл
				Если КлючЗначение.Ключ = "Содержание" Тогда
					ПараметрыЗадача[КлючЗначение.Ключ]=МодульКаналаОповещения.ТекстКомментарияПреобразованный(
						Сообщение.ДополнительныеПараметры.Задача, Задача[КлючЗначение.Ключ], Сообщение);
				ИначеЕсли КлючЗначение.Ключ="Номер" Тогда 
					ПараметрыЗадача[КлючЗначение.Ключ]=Формат(Задача[КлючЗначение.Ключ],"ЧГ=0;");
				Иначе
					ПараметрыЗадача[КлючЗначение.Ключ]=Задача[КлючЗначение.Ключ];
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

		ТекстКомментария="";
		Если ЗначениеЗаполнено(Сообщение.ДополнительныеПараметры.Комментарий) Тогда
			ТекстКомментария=МодульКаналаОповещения.ТекстКомментарияПреобразованный(
			Сообщение.ДополнительныеПараметры.Инициатор, Сообщение.ДополнительныеПараметры.Комментарий, Сообщение);
		КонецЕсли;
		Сообщение.ЗначенияРеквизитов["ТекстКомментария"]=ТекстКомментария;
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
Процедура ОтправкаОповещенийПоЗадачам() Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ОповещенияПоЗадачамКОтправке.Идентификатор,
	|	ОповещенияПоЗадачамКОтправке.ИдентификаторТранзакции,
	|	ОповещенияПоЗадачамКОтправке.Событие,
	|	ОповещенияПоЗадачамКОтправке.ИнициаторСобытия,
	|	ОповещенияПоЗадачамКОтправке.ДатаОтправки
	|ИЗ
	|	РегистрСведений.ОповещенияПоЗадачамКОтправке КАК ОповещенияПоЗадачамКОтправке
	|ГДЕ
	|	ОповещенияПоЗадачамКОтправке.ДатаОтправки = &ПустаяДата
	|	И ОповещенияПоЗадачамКОтправке.КоличествоПопыток <= 3";
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Попытка
			ОтправитьОповещение(Выборка.ИдентификаторТранзакции, Выборка.Идентификатор, Выборка.Событие,
				Выборка.ИнициаторСобытия);
		Исключение
			ЗаписьЖурналаРегистрации("Задачи.ОтправкаОповещения", УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.ОповещенияПоЗадачамКОтправке, Выборка.Идентификатор,
				"Ошибка отправки оповещения: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписьюОбъектаФормированиеДанныхДляОповещений(Источник, Отказ) Экспорт
	ДанныеТранзакцииОповещений=НовыйДанныеТранзакцииОповещенияОбъекта();
	ДанныеТранзакцииОповещений.ЭтоНовый=Источник.ЭтоНовый();
	ДанныеТранзакцииОповещений.Изменения=УправлениеЗадачами.ИзмененияОбъектаПередЗаписью(Источник);
	ДанныеТранзакцииОповещений.ЭтоЗадача=ТипЗнч(Источник) = Тип("ДокументОбъект.Задача");
	ЗаполнитьСобытияЗаписиОбъекта(Источник, ДанныеТранзакцииОповещений);
	ДанныеТранзакцииОповещений.Вставить("ЭтоИзменениеИзВнешнихИсточников", Источник.ДополнительныеСвойства.Свойство(
		"ЭтоИзменениеИзВнешнихИсточников"));
	Источник.ДополнительныеСвойства.Вставить("ДанныеТранзакцииОповещений", ДанныеТранзакцииОповещений);
КонецПроцедуры

Процедура ПриЗаписиОбъектаФормированиеДанныхОповещений(Источник, Отказ) Экспорт
	ДанныеТранзакцииОповещений=Источник.ДополнительныеСвойства.ДанныеТранзакцииОповещений;
	ДанныеТранзакцииОповещений.Инициатор=Источник.Ссылка;
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.Задача") Тогда
		ДанныеТранзакцииОповещений.Задача=Источник.Ссылка;
	Иначе
		ДанныеТранзакцииОповещений.Задача=Источник.Задача;
	КонецЕсли;

	//Запишем присоединенныые файлы
	Если Источник.ДополнительныеСвойства.Свойство("ДанныеПрисоединенныхФайлов") Тогда
		УправлениеЗадачами.ЗаписатьПрисоединенныеФайлыПоДаннымПрисоединенныхФайловРедакторов(
			ДанныеТранзакцииОповещений.Задача, Источник.ДополнительныеСвойства.ДанныеПрисоединенныхФайлов,
			Источник.Ссылка);
	КонецЕсли;

	ДанныеТранзакцииОповещений.Проект=ДанныеТранзакцииОповещений.Задача.Проект;
	ДанныеТранзакцииОповещений.Партнер=ДанныеТранзакцииОповещений.Проект.Партнер;
	Если ЗначениеЗаполнено(ДанныеТранзакцииОповещений.Проект.НастройкаОповещенияПоЗадачам) Тогда
		НастройкаОповещения=ДанныеТранзакцииОповещений.Проект.НастройкаОповещенияПоЗадачам;
	ИначеЕсли ЗначениеЗаполнено(ДанныеТранзакцииОповещений.Партнер.НастройкаОповещенияПоЗадачам) Тогда
		НастройкаОповещения=ДанныеТранзакцииОповещений.Партнер.НастройкаОповещенияПоЗадачам;
	Иначе
		НастройкаОповещения=Справочники.НастройкиОповещенийПоЗадачам.ПоУмолчанию;
	КонецЕсли;
	ДанныеТранзакцииОповещений.Вставить("УстанавливатьОтправителемУведомленияАвтораСобытия",
		НастройкаОповещения.УстанавливатьОтправителемУведомленияАвтораСобытия);

	НаборВсеСобытия=Справочники.НаборыСобытийОповещений.ВсеСобытия;

	Для Каждого СтрокаТЧ Из НастройкаОповещения.НастройкиТранспорта Цикл
		ДополнительныеПолучателиОповещения=Новый Массив;
		
		ОтборСтрок=Новый Структура;
		ОтборСтрок.Вставить("КлючСтроки", СтрокаТЧ.КлючСтроки);
		НайденныеСтроки=НастройкаОповещения.ДополнительныеПолучателиОповещений.НайтиСтроки(ОтборСтрок);
		Для Каждого Стр Из НайденныеСтроки Цикл
			Получатель=Новый Структура();
			Получатель.Вставить("Адрес", Стр.Адрес);
			Получатель.Вставить("Представление", Стр.Представление);
			ДополнительныеПолучателиОповещения.Добавить(Получатель);
		КонецЦикла;
		ДанныеТранзакцииОповещений.ДополнительныеПолучатели=ДополнительныеПолучателиОповещения;
		
		Для Каждого Событие Из ДанныеТранзакцииОповещений.События Цикл
			СобытиеВходитВНабор=СтрокаТЧ.НаборСобытий = НаборВсеСобытия Или СтрокаТЧ.НаборСобытий.События.Найти(
				Событие, "Событие")<>Неопределено;

			Если СобытиеВходитВНабор Тогда
				ЗарегистрироватьОповещениеКОтправке(ДанныеТранзакцииОповещений.Задача, Событие, Источник.Ссылка,
					ДанныеТранзакцииОповещений, СтрокаТЧ.ШаблонСообщения, СтрокаТЧ.УчетнаяЗаписьОповещений);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

//	ЗапуститьОтправкуОповещенийПоТранзакции(ДанныеТранзакцииОповещений);
КонецПроцедуры

Процедура ЗапуститьОтправкуОповещенийПоТранзакции(ДанныеТранзакцииОповещений)

	ПараметрыПроцедуры=Новый Структура;
	ПараметрыПроцедуры.Вставить("Транзакция", ДанныеТранзакцииОповещений);
	ПараметрыВыполнения=ДлительныеОперации.ПараметрыВыполненияВФоне(Неопределено);
	ПараметрыВыполнения.ЗапуститьВФоне=Истина;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания="Отправка оповещений по задаче " + ДанныеТранзакцииОповещений.Задача;
//	ОтправитьОповещенияПоТранзакцииОповещений(ПараметрыПроцедуры, Неопределено);

	ДлительныеОперации.ВыполнитьВФоне("ОповещенияПоЗадачам.ОтправитьОповещенияПоТранзакцииОповещений",
		ПараметрыПроцедуры, ПараметрыВыполнения);

КонецПроцедуры

Процедура ОтправитьОповещенияПоТранзакцииОповещений(ПараметрыПроцедуры, АдресРезультата) Экспорт
	УстановитьПривилегированныйРежим(Истина);

	Транзакция=ПараметрыПроцедуры.Транзакция;
	ЗаписьЖурналаРегистрации("Задачи.ОтправкаОповещения", УровеньЖурналаРегистрации.Информация, Документы.Задача,
		Метаданные.РегистрыСведений.ОповещенияПоЗадачамКОтправке,
		"Начало отправки оповещения по транзакции оповещений " + Транзакция.Идентификатор + " по задаче");

	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ОповещенияПоЗадачамКОтправке.Идентификатор,
	|	ОповещенияПоЗадачамКОтправке.ИдентификаторТранзакции,
	|	ОповещенияПоЗадачамКОтправке.Событие,
	|	ОповещенияПоЗадачамКОтправке.ИнициаторСобытия,
	|	ОповещенияПоЗадачамКОтправке.ДатаОтправки
	|ИЗ
	|	РегистрСведений.ОповещенияПоЗадачамКОтправке КАК ОповещенияПоЗадачамКОтправке
	|ГДЕ
	|	ОповещенияПоЗадачамКОтправке.ИдентификаторТранзакции = &ИдентификаторТранзакции";
	Запрос.УстановитьПараметр("ИдентификаторТранзакции", Транзакция.Идентификатор);

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ДатаОтправки) Тогда
			Продолжить;
		КонецЕсли;
		ОтправитьОповещение(Выборка.ИдентификаторТранзакции, Выборка.Идентификатор, Выборка.Событие,
			Выборка.ИнициаторСобытия);
	КонецЦикла;

	ЗаписьЖурналаРегистрации("Задачи.ОтправкаОповещения", УровеньЖурналаРегистрации.Информация, Документы.Задача,
		Метаданные.РегистрыСведений.ОповещенияПоЗадачамКОтправке,
		"Начало отправки оповещения по транзакции оповещений " + Транзакция.Идентификатор + " по задаче");

КонецПроцедуры

Процедура ОтправитьОповещение(ИдентификаторТранзакции, Идентификатор, Событие, ИнициаторСобытия) Экспорт
	МенеджерЗаписи=РегистрыСведений.ОповещенияПоЗадачамКОтправке.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИдентификаторТранзакции=ИдентификаторТранзакции;
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
	Если ДанныеСобытия.ЭтоИзменениеИзВнешнихИсточников = Истина Тогда
		ДанныеСобытия.Вставить("Автор", ИнициаторСобытия.Основание.ОтправительКонтакт);
		Если Не ЗначениеЗаполнено(ДанныеСобытия.Автор) Тогда
			ДанныеСобытия.Вставить("Автор", "" + ИнициаторСобытия.Основание.ОтправительПредставление + "<"
				+ ИнициаторСобытия.Основание.ОтправительАдрес + ">");
		КонецЕсли;
	Иначе
		ДанныеСобытия.Вставить("Автор", МенеджерЗаписи.Автор);
	КонецЕсли;
	ДанныеСобытия.Вставить("АвторОповещения", МенеджерЗаписи.Автор);
	ДанныеСобытия.Вставить("Дата", МенеджерЗаписи.Дата);
	ДанныеСобытия.Вставить("Задача", МенеджерЗаписи.Задача);
	ДанныеСобытия.Вставить("УчетнаяЗаписьОповещения", МенеджерЗаписи.УчетнаяЗапись);
	ДанныеСобытия.Вставить("СобытиеОповещения", МенеджерЗаписи.Событие);
	Если ТипЗнч(ИнициаторСобытия) = Тип("СправочникСсылка.КомментарииЗадач") Тогда
		ДанныеСобытия.Вставить("Комментарий", ИнициаторСобытия.ТекстСообщения);
		ДанныеСобытия.Вставить("КомментарийHTML", ИнициаторСобытия.ТекстСообщенияHTML);
		ДанныеСобытия.Вставить("ФорматКомментария", РедакторКомментария.ФорматТекстаРедактирования(
			ИнициаторСобытия.ТекстСообщенияФормат));
	ИначеЕсли ДанныеСобытия.ЭтоНовый Тогда
		ДанныеСобытия.Вставить("Комментарий", ИнициаторСобытия.Содержание);
		ДанныеСобытия.Вставить("КомментарийHTML", ИнициаторСобытия.СодержаниеHTML);
		ДанныеСобытия.Вставить("ФорматКомментария", РедакторКомментария.ФорматТекстаРедактирования(
			ИнициаторСобытия.СодержаниеФормат));
	Иначе
		ДанныеСобытия.Вставить("Комментарий", "");
		ДанныеСобытия.Вставить("КомментарийHTML", "");
		ДанныеСобытия.Вставить("ФорматКомментария", Перечисления.ВариантыОформленияТекста.HTML);
	КонецЕсли;

	ДанныеСобытия.Вставить("ИзмененияКлючевыхРеквизитов", Новый Структура);
	КлючевыеРеквизиты=УправлениеЗадачамиКлиентСервер.КлючевыеРеквизитыЗадачи();
	Для Каждого КлючЗначение Из ДанныеСобытия.Изменения Цикл
		Если КлючевыеРеквизиты.Найти(КлючЗначение.Ключ) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеИзменение=Новый Структура;
		
		Для Каждого КЗ ИЗ КлючЗначение.Значение Цикл
			Если Не ЗначениеЗаполнено(КЗ.Значение) Тогда
				НовоеИзменение.Вставить(КЗ.Ключ, "<Пусто>");
			Иначе
				НовоеИзменение.Вставить(КЗ.Ключ, КЗ.Значение);
			КонецЕсли;
		КонецЦикла;
		
		ДанныеСобытия.ИзмененияКлючевыхРеквизитов.Вставить(КлючЗначение.Ключ, НовоеИзменение);
	КонецЦикла;

	Сообщение = ШаблоныСообщений.СформироватьСообщение(МенеджерЗаписи.ШаблонСообщения, ДанныеСобытия.Задача,
		Новый УникальныйИдентификатор, ДанныеСобытия);

	НастройкиОтправкиОповещения=Новый Структура;
	НастройкиОтправкиОповещения.Вставить("УстанавливатьОтправителемУведомленияАвтораСобытия",
		ДанныеСобытия.УстанавливатьОтправителемУведомленияАвтораСобытия);
	НастройкиОтправкиОповещения.Вставить("Автор", ДанныеСобытия.Автор);
	МодульКаналаОповещения=МодульКаналаОповещенияПоУчетнойЗаписи(МенеджерЗаписи.УчетнаяЗапись);

	ЗаполнитьПолучателейСообщенияОповещения(Сообщение, ДанныеСобытия);

	//Если есть кому отправлять отдаем каналу сообщение для отправки
	Если Сообщение.Получатель.Количество() > 0 Тогда
		Если МодульКаналаОповещения = Неопределено Тогда
			Ошибка="Выбранный канал оповещения не поддерживается";
		Иначе
			Попытка
				МодульКаналаОповещения.ВыполнитьОтправкуСообщения(Сообщение, МенеджерЗаписи.УчетнаяЗапись, Ошибка,
					НастройкиОтправкиОповещения);
			Исключение
				Ошибка=ОписаниеОшибки();
			КонецПопытки;
			Если Не ЗначениеЗаполнено(Ошибка) Тогда
				ДатаОтправки=ТекущаяДатаСеанса();
			КонецЕсли;
		КонецЕсли;
	Иначе
		ДатаОтправки=ТекущаяДатаСеанса();
	КонецЕсли;

	МенеджерЗаписи.КоличествоПопыток=МенеджерЗаписи.КоличествоПопыток + 1;
	МенеджерЗаписи.Ошибка=Ошибка;
	МенеджерЗаписи.ДатаОтправки=ДатаОтправки;
	МенеджерЗаписи.Записать(Истина);

	Если ЗначениеЗаполнено(Ошибка) Тогда
		ЗаписьЖурналаРегистрации("Задачи.ОтправкаОповещения", УровеньЖурналаРегистрации.Ошибка, Документы.Задача,
			МенеджерЗаписи.Задача, "Отправки оповещения " + Идентификатор + " по задаче завершилось с ошибкой "
			+ Ошибка);
	Иначе
		ЗаписьЖурналаРегистрации("Задачи.ОтправкаОповещения", УровеньЖурналаРегистрации.Информация, Документы.Задача,
			МенеджерЗаписи.Задача, "Окончание отправки оповещения " + Идентификатор + " по задаче");
	КонецЕсли;
КонецПроцедуры

Процедура ОтправитьОповещенияНеотправленныеПриЗаписи() Экспорт

КонецПроцедуры

Функция ИзвлеченныйТекстИзHTML(СтрокаHTML) Экспорт
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(СтрокаHTML);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументHTML = ПостроительDOM.Прочитать(ЧтениеHTML);
	ЧтениеHTML.Закрыть();

	Возврат ДокументHTML.ИзвлечьТолькоТекст();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура ДобавитьПотенциальногоПолучателя(ПотенциальныеПолучатели, Получатель, ПредметСообщения) Экспорт
	Если Не ЗначениеЗаполнено(Получатель) Тогда
		Возврат;
	КонецЕсли;

	Если Получатель = ПредметСообщения.АвторОповещения Тогда
		Возврат;
	КонецЕсли;

	Если ПотенциальныеПолучатели.Найти(Получатель) <> Неопределено Тогда
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
	// Наблюдатели
	ДанныеНаблюдателей=УправлениеЗадачами.ДанныеНаблюдателейПредмета(Задача);
	Для Каждого ТекНаблюдатель Из ДанныеНаблюдателей Цикл
		ДобавитьПотенциальногоПолучателя(МассивПотенциальныхПолучателей, ТекНаблюдатель.Наблюдатель, ДанныеСобытия);
	КонецЦикла;

	Если ТипЗнч(ДанныеСобытия.Инициатор) = Тип("СправочникСсылка.КомментарииЗадач") Тогда
		Если ДанныеСобытия.Инициатор.ОтправитьСообщениеКонтакту Тогда
			Для Каждого Получатель Из ДанныеСобытия.Инициатор.ДополнительныеПолучателиОповещения Цикл
				Если Не ЗначениеЗаполнено(Получатель.Адрес) Тогда
					Продолжить;
				КонецЕсли;

				ПолучательСообщения = Новый Структура;
				ПолучательСообщения.Вставить("Представление", Получатель.Представление);
				ПолучательСообщения.Вставить("ВариантОтправки", Получатель.ВариантОтправки);
				ПолучательСообщения.Вставить("Адрес", Получатель.Адрес);
				ПолучательСообщения.Вставить("ИсточникКонтактнойИнформации", Получатель.Контакт);
				Сообщение.Получатель.Добавить(ПолучательСообщения);
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеСобытия.Инициатор) = Тип("ДокументСсылка.Задача") И ДанныеСобытия.ЭтоНовый Тогда
		ДобавитьПотенциальногоПолучателя(МассивПотенциальныхПолучателей, Задача.КонтактОбращения, ДанныеСобытия);

		Для Каждого Получатель Из ДанныеСобытия.Инициатор.ПолучателиКопий Цикл
			Если Не ЗначениеЗаполнено(Получатель.Адрес) Тогда
				Продолжить;
			КонецЕсли;

			ПолучательСообщения = Новый Структура;
			ПолучательСообщения.Вставить("Представление", Получатель.Представление);
			ПолучательСообщения.Вставить("ВариантОтправки", Получатель.ВариантОтправки);
			ПолучательСообщения.Вставить("Адрес", Получатель.Адрес);
			ПолучательСообщения.Вставить("ИсточникКонтактнойИнформации", Получатель.Контакт);
			Сообщение.Получатель.Добавить(ПолучательСообщения);
		КонецЦикла;
	КонецЕсли;

	Для Каждого Получатель Из МассивПотенциальныхПолучателей Цикл
		Адрес=МодульКаналаОповещения.АдресПолучателя(Получатель);
		Если Не ЗначениеЗаполнено(Адрес) Тогда
			Продолжить;
		КонецЕсли;

		ПолучательСообщения = Новый Структура;
		ПолучательСообщения.Вставить("ВариантОтправки", "Кому:");
		ПолучательСообщения.Вставить("Представление", Строка(Получатель));
		ПолучательСообщения.Вставить("Адрес", МодульКаналаОповещения.АдресПолучателя(Получатель));
		ПолучательСообщения.Вставить("ИсточникКонтактнойИнформации", Получатель);
		Сообщение.Получатель.Добавить(ПолучательСообщения);
	КонецЦикла;

	Если ДанныеСобытия.Свойство("ДополнительныеПолучатели") Тогда
		Для Каждого ТекПолучатель Из ДанныеСобытия.ДополнительныеПолучатели Цикл
			ПолучательСообщения = Новый Структура;
			ПолучательСообщения.Вставить("ВариантОтправки", "Кому:");
			ПолучательСообщения.Вставить("Представление", ТекПолучатель.Представление);
			ПолучательСообщения.Вставить("Адрес", ТекПолучатель.Адрес);
			ПолучательСообщения.Вставить("ИсточникКонтактнойИнформации", Неопределено);
			Сообщение.Получатель.Добавить(ПолучательСообщения);
		КонецЦикла;
	КонецЕсли;
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
	Данные.Вставить("ДополнительныеПолучатели", Новый Массив);

	Возврат Данные;
КонецФункции

Процедура ЗарегистрироватьОповещениеКОтправке(Задача, Событие, ИнициаторСобытия, ДанныеСобытия, ШаблонСообщения,
	УчетнаяЗапись) Экспорт
	НовоеОповещение=РегистрыСведений.ОповещенияПоЗадачамКОтправке.СоздатьМенеджерЗаписи();
	НовоеОповещение.Событие=Событие;
	НовоеОповещение.ИдентификаторТранзакции=ДанныеСобытия.Идентификатор;
	НовоеОповещение.Идентификатор=Новый УникальныйИдентификатор;
	НовоеОповещение.ИнициаторСобытия=ИнициаторСобытия;

	НовоеОповещение.Задача=Задача;
	Если ДанныеСобытия.ЭтоИзменениеИзВнешнихИсточников = Истина Тогда
		НовоеОповещение.Автор=Справочники.Пользователи.ПустаяСсылка();
	Иначе
		НовоеОповещение.Автор=Пользователи.ТекущийПользователь();
	КонецЕсли;
	НовоеОповещение.Дата=ТекущаяДатаСеанса();
	НовоеОповещение.ШаблонСообщения=ШаблонСообщения;
	НовоеОповещение.УчетнаяЗапись=УчетнаяЗапись;
	НовоеОповещение.ДанныеСобытия=Новый ХранилищеЗначения(ДанныеСобытия, Новый СжатиеДанных(9));
	НовоеОповещение.Записать(Истина);
КонецПроцедуры

Процедура ЗаполнитьСобытияЗаписиОбъекта(Источник, ДанныеТранзакцииОповещений)
	Если ТипЗнч(Источник) = Тип("ДокументОбъект.Задача") Тогда
		Если ДанныеТранзакцииОповещений.ЭтоНовый Тогда
			ДанныеТранзакцииОповещений.События.Добавить(Перечисления.СобытияОповещений.НоваяЗадача);
		Иначе
			ЕстьИзменениеКлючевогоРеквизита=Ложь;
			КлючевыеРеквизиты=УправлениеЗадачамиКлиентСервер.КлючевыеРеквизитыЗадачи();
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
#КонецОбласти