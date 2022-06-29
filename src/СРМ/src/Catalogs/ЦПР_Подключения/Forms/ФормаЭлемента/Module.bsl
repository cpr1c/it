&НаСервере
Процедура УстановитьАдресПодключения()
	Объект.АдресПодключения=Справочники.ЦПР_Подключения.ПолучитьАдресПодключения(Объект.Адрес,объект.Порт);	
КонецПроцедуры

&НаКлиенте
Процедура АдресПриИзменении(Элемент)
	УстановитьАдресПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ПортПриИзменении(Элемент)
	УстановитьАдресПодключения();
КонецПроцедуры

&НаКлиенте
Процедура ВипПодключенияПриИзменении(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	Элементы.ГруппаПарольДляПодключенийБезЛогина.Видимость=Объект.ВидПодключения.БезЛогина;	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	Если ТекущийОбъект.ВидПодключения.БезЛогина Тогда
		МенеджерЧтения=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.СоздатьМенеджерЗаписи();
		МенеджерЧтения.Логин="";
		МенеджерЧтения.ТочкаПодключения=ТекущийОбъект.Ссылка;
		МенеджерЧтения.Прочитать();
		
		Если Не МенеджерЧтения.Выбран() Тогда
			МенеджерЧтения.Логин="";
			МенеджерЧтения.ТочкаПодключения=ТекущийОбъект.Ссылка;
		КонецЕсли;
		
		ЗначениеВРеквизитФормы(МенеджерЧтения,"УчетныеДанныеПодключения");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ТекущийОбъект.ВидПодключения.БезЛогина Тогда
		МенеджерЗаписи=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ТочкаПодключения=ТекущийОбъект.Ссылка;
		МенеджерЗаписи.Логин="";
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи,УчетныеДанныеПодключения,,"ТочкаПодключения,Логин");
		
		Если не МенеджерЗаписи.ПроверитьЗаполнение() Тогда
			Отказ=Истина;
		КонецЕсли;
		
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	//Если ОБъект.ВидПодключения.БезЛогина Тогда
	//	ПроверяемыеРеквизиты.Добавить("УчетныеДанныеПодключения.Вид");		
	//КонецЕсли;
КонецПроцедуры
