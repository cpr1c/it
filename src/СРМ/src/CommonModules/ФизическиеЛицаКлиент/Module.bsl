#Область ПрограммныйИнтерфейс

Процедура НачатьСозданиеФизическогоЛицаПривязанногоКПартнеру(ПартнерПроект, ЭлементФормы = Неопределено,
	РежимВыбора = Ложь) Экспорт
	ПараметрыФормы=Новый Структура;
	ПараметрыФормы.Вставить("Партнер", ПартнерПроект);
	ПараметрыФормы.Вставить("РежимВыбора", РежимВыбора);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаЭлемента", ПараметрыФормы, ЭлементФормы);

КонецПроцедуры

Процедура НачалоВыбораФизическогоЛицаПривязанногоКПартнеру(ПартнерПроект, Элемент, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;

	ПараметрыФормы=Новый Структура;
	ПараметрыФормы.Вставить("Партнер", ПартнерПроект);
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// предназначен для модулей, которые являются частью некоторой функциональной подсистемы. В нем должны быть размещены экспортные процедуры и функции, которые допустимо вызывать только из других функциональных подсистем этой же библиотеки.
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// содержит процедуры и функции, составляющие внутреннюю реализацию общего модуля. В тех случаях, когда общий модуль является частью некоторой функциональной подсистемы, включающей в себя несколько объектов метаданных, в этом разделе также могут быть размещены служебные экспортные процедуры и функции, предназначенные только для вызова из других объектов данной подсистемы.
#КонецОбласти