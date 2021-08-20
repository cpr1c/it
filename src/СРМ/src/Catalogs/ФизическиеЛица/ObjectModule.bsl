///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	УстановитьПолеПоСпискуКонтактнойИнформации("Телефоны", Перечисления.ТипыКонтактнойИнформации.Телефон);
	УстановитьПолеПоСпискуКонтактнойИнформации("АдресаЭлектроннойПочты",
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

Процедура УстановитьПолеПоСпискуКонтактнойИнформации(ИмяРеквизита, ТипКонтактнойИнформации) Экспорт
	ЗначениеПоля = "";
	
	Для Каждого СтрокаКИ ИЗ КонтактнаяИнформация Цикл
		Если СтрокаКИ.Тип<>ТипКонтактнойИнформации Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СокрЛП(СтрокаКИ.Представление)) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеПоля = ЗначениеПоля +?(ЗначениеЗаполнено(ЗначениеПоля),";", "") + СокрЛП(СтрокаКИ.Представление);
	КонецЦикла;
	
	ЭтотОбъект[ИмяРеквизита] = ЗначениеПоля;
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения:                Без ограничения.
	// Изменения:             Без ограничения.
	
	// Чтение, Добавление, Изменение: набор №0.
	Строка = Таблица.Добавить();
	Строка.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

