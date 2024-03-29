#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Закрыт");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветФона");
	ЭлементЦветаОформления.Значение = WebЦвета.СветлоГрифельноСерый;
	ЭлементЦветаОформления.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокИлиЕгоУсловноеОформление, "Закрыт", Ложь, 
		ВидСравненияКомпоновкиДанных.Равно, "Только открытые", Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных .БыстрыйДоступ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли