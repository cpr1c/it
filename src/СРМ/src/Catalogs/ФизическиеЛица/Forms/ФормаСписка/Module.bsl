///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Если Параметры.Свойство("Партнер") Тогда
		Если ТипЗнч(Параметры.Партнер) = Тип("СправочникСсылка.Проекты") Тогда
			Партнер = Параметры.Партнер.Партнер;
		Иначе
			Партнер = Параметры.Партнер;
		КонецЕсли;
	КонецЕсли;
	
	ТолькоКонтактыПривязанныеКПартнеру = ЗначениеЗаполнено(Партнер);

	Список.Параметры.УстановитьЗначениеПараметра("ФильтрПоПартнерам", ТолькоКонтактыПривязанныеКПартнеру);
	Список.Параметры.УстановитьЗначениеПараметра("Партнеры", Партнер);
	
	Элементы.ГруппаФильтрПоПартнеру.Видимость = ЗначениеЗаполнено(Партнер);
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТолькоКонтактыПривязанныеКПартнеруПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ФильтрПоПартнерам", ТолькоКонтактыПривязанныеКПартнеру);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)

	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	Если Не ЗначениеЗаполнено(Партнер) Тогда
		Возврат;
	КонецЕсли;	
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Отказ=Истина;
	
	ФизическиеЛицаКлиент.НачатьСозданиеФизическогоЛицаПривязанногоКПартнеру(Партнер);
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПоискИУдалениеДублей

&НаКлиенте
Процедура ОбъединитьВыделенные(Команда)
	
	ПоискИУдалениеДублейКлиент.ОбъединитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьМестаИспользования(Команда)
	
	ПоискИУдалениеДублейКлиент.ПоказатьМестаИспользования(Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПоискИУдалениеДублей

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


#КонецОбласти

