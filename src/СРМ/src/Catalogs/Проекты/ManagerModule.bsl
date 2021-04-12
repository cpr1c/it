
// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Вызывается при создании формы списка подключений на сервере.
//
// Параметры:
//  СписокПодключенийИлиЕгоУсловноеОформление - ДинамическийСписок, УсловноеОформлениеКомпоновкиДанных - условное
//   оформление списка подключений.
//
Процедура УстановитьОформлениеСписка(Знач СписокПодключенийИлиЕгоУсловноеОформление) Экспорт
	Если ТипЗнч(СписокПодключенийИлиЕгоУсловноеОформление) = Тип("ДинамическийСписок") Тогда
		УсловноеОформлениеСпискаПодключений = СписокПодключенийИлиЕгоУсловноеОформление.КомпоновщикНастроек.Настройки.УсловноеОформление;
		УсловноеОформлениеСпискаПодключений.ИдентификаторПользовательскойНастройки = "ОсновноеОформление";
	Иначе
		УсловноеОформлениеСпискаПодключений = СписокПодключенийИлиЕгоУсловноеОформление;
	КонецЕсли;
	
	// Удаление предустановленных элементов оформления.
	Предустановленные = Новый Массив;
	Элементы = УсловноеОформлениеСпискаПодключений.Элементы;
	Для каждого ЭлементУсловногоОформления Из Элементы Цикл
		Если ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
			Предустановленные.Добавить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	Для каждого ЭлементУсловногоОформления Из Предустановленные Цикл
		Элементы.Удалить(ЭлементУсловногоОформления);
	КонецЦикла;
		
	// Установка оформления для архива
	ЭлементУсловногоОформления = УсловноеОформлениеСпискаПодключений.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Архивный");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = WebЦвета.СветлоГрифельноСерый;
	ЭлементЦветаОформления.Использование = Истина;
КонецПроцедуры



Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Параметры.СтрокаПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка=Ложь;
	
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Проекты.Ссылка,
	|	Проекты.Наименование,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Проекты.Партнер) КАК Партнер
	|ИЗ
	|	Справочник.Проекты КАК Проекты
	|ГДЕ
	|	НЕ Проекты.Архивный
	|	И (Проекты.Наименование ПОДОБНО &Наименование
	|	ИЛИ Проекты.Партнер.Наименование ПОДОБНО &Наименование)";
	Запрос.УстановитьПараметр("Наименование", "%"+Параметры.СтрокаПоиска+"%");
	
	ДанныеВыбора=Новый СписокЗначений();
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка, 
			СтроковыеФункцииКлиентСерверРФ.НайтиПодстрокуИВыделить(Выборка.Наименование+"("+Выборка.Партнер+")",Параметры.СтрокаПоиска));
	КонецЦикла;
	
КонецПроцедуры
