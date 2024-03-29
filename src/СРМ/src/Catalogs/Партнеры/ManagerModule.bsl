#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("КонтактнаяИнформация.*");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗащитаПерсональныхДанных") Тогда
		МодульЗащитаПерсональныхДанных = ОбщегоНазначения.ОбщийМодуль("ЗащитаПерсональныхДанных");
		МодульЗащитаПерсональныхДанных.ДобавитьКомандуПечатиСогласияНаОбработкуПерсональныхДанных(КомандыПечати);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ 
	|	ЗначениеРазрешено(Ссылка)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

// Вызывается при создании формы списка подключений на сервере.
//
// Параметры:
//  СписокИлиЕгоУсловноеОформление - ДинамическийСписок, УсловноеОформлениеКомпоновкиДанных - условное
//   оформление списка подключений.
//
Процедура УстановитьОформлениеСписка(Знач СписокИлиЕгоУсловноеОформление) Экспорт
	
	Если ТипЗнч(СписокИлиЕгоУсловноеОформление) = Тип("ДинамическийСписок") Тогда
		УсловноеОформлениеСпискаПодключений = СписокИлиЕгоУсловноеОформление.КомпоновщикНастроек.Настройки.УсловноеОформление;
		УсловноеОформлениеСпискаПодключений.ИдентификаторПользовательскойНастройки = "ОсновноеОформление";
	Иначе
		УсловноеОформлениеСпискаПодключений = СписокИлиЕгоУсловноеОформление;
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
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка.Архив");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветФона");
	ЭлементЦветаОформления.Значение = WebЦвета.СветлоГрифельноСерый;
	ЭлементЦветаОформления.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокИлиЕгоУсловноеОформление, "Ссылка.Архив", Ложь, 
		ВидСравненияКомпоновкиДанных.Равно, "Только активные", Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных .БыстрыйДоступ);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли