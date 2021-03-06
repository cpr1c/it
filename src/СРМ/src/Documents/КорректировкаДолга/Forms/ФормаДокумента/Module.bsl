
&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()
	ОтображатьРеквизитыИсточника = (Объект.ВидОперации=ПредопределенноеЗначение("Перечисление.ВидыОперацийКоректировкаДолга.ПеренесениеДолга"));
	Элементы.ГруппаДоговорИсточник.Видимость=ОтображатьРеквизитыИсточника;
	Элементы.ТекущаяЗадолженностьИсточника.Видимость = ОтображатьРеквизитыИсточника;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
	ОбновитьЗадолженностьПоДоговору();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗадолженностьПоДоговору(ОбновлятьПоИсточнику = Истина, ОбновлятьПоПриемнику = Истина)
	
	Если ОбновлятьПоИсточнику Тогда
		ТекущаяЗадолженностьИсточника = Аренда.ПолучитьЗадолженностьПоДоговору(КонецДня(Объект.Дата), Объект.ДоговорИсточник, Объект.КБКИсточник, Объект.ТипВзаиморасчетов, Объект.Контрагент);
	КонецЕсли;
	
	Если ОбновлятьПоПриемнику Тогда
		ТекущаяЗадолженностьКонтрагента = Аренда.ПолучитьЗадолженностьПоДоговору(КонецДня(Объект.Дата), Объект.Договор, Объект.КБК, Объект.ТипВзаиморасчетов, Объект.КонтрагентИсточник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	
	СтруктуаДоговора=Аренда.ПолучитьСтруктуруДАнныхДоговора(Объект.Дата,Объект.Договор);
	
	Объект.КБК=СтруктуаДоговора.КБК;
	Объект.Контрагент = СтруктуаДоговора.Контрагент;
	
	ОбновитьЗадолженностьПоДоговору(Ложь, Истина);
	
КонецПроцедуры


&НаКлиенте
Процедура ДоговорИсточникПриИзменении(Элемент)
	
	СтруктуаДоговора=Аренда.ПолучитьСтруктуруДАнныхДоговора(Объект.Дата,Объект.ДоговорИсточник);
	
	Объект.КБКИсточник=СтруктуаДоговора.КБК;
	Объект.КонтрагентИсточник = СтруктуаДоговора.Контрагент;
	
	ОбновитьЗадолженностьПоДоговору(Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КБКИсточникПриИзменении(Элемент)
	ОбновитьЗадолженностьПоДоговору(Истина, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КБКПриИзменении(Элемент)
	ОбновитьЗадолженностьПоДоговору(Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КорректируемыйМесяцПриИзменении(Элемент)
	
	Объект.КорректируемыйМесяц = НачалоМесяца(Объект.КорректируемыйМесяц);
	ОбновитьЗадолженностьПоДоговору();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбновитьЗадолженностьПоДоговору();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентИсточникПриИзменении(Элемент)
	ОбновитьЗадолженностьПоДоговору(Истина, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ОбновитьЗадолженностьПоДоговору(Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДоговорИсточникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(Объект.КонтрагентИсточник) Тогда
		Отбор.Вставить("Контрагент", Объект.КонтрагентИсточник);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Отбор.Вставить("Контрагент", Объект.Контрагент);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
