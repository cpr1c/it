///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущийКонтекст;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		ВызватьИсключение НСтр("ru = 'Текущий режим работы не поддерживается.'");
	КонецЕсли;
	
	ОтображаемыеИсправления = Параметры.Исправления;
	
	Если ОбщегоНазначения.ЭтоВебКлиент()
		Или ОбщегоНазначения.РазделениеВключено()
		Или ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ()
		Или Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Элементы.ФормаУстановитьИсправление.Видимость = Ложь;
		Элементы.ФормаУдалитьИсправление.Видимость    = Ложь;
		Элементы.ГруппаИнформация.Видимость           = Ложь;
	КонецЕсли;
	
	ОбновитьСписокИсправлений();
	
	Элементы.УстановленныеИсправленияПрименимоДля.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияЖурналРегистрацииНажатие(Элемент)
	МассивСобытий = Новый Массив;
	МассивСобытий.Добавить(НСтр("ru = 'Исправления. Установка'"));
	МассивСобытий.Добавить(НСтр("ru = 'Исправления. Изменение'"));
	МассивСобытий.Добавить(НСтр("ru = 'Исправления. Удаление'"));
	Отбор = Новый Структура("СобытиеЖурналаРегистрации", МассивСобытий);
	ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУстановленныеИсправления

&НаКлиенте
Процедура УстановленныеИсправленияПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	УдалитьРасширения(Элемент.ВыделенныеСтроки);
КонецПроцедуры

&НаКлиенте
Процедура УстановленныеИсправленияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	Оповещение = Новый ОписаниеОповещения("ПослеУстановкиИсправлений", ЭтотОбъект);
	ОткрытьФорму("Обработка.УстановкаОбновлений.Форма.Форма",,,,,, Оповещение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокИсправлений()
	
	УстановленныеИсправления.Очистить();
	Элементы.УстановленныеИсправленияПутьКФайлу.Видимость = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	Расширения = РасширенияКонфигурации.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Для Каждого Расширение Из Расширения Цикл
		
		Если Не ОбновлениеКонфигурации.ЭтоИсправление(Расширение) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ОтображаемыеИсправления <> Неопределено И ОтображаемыеИсправления.НайтиПоЗначению(Расширение.Имя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СвойстваИсправления = ОбновлениеКонфигурации.СвойстваИсправления(Расширение.Имя);
		
		НоваяСтрока = УстановленныеИсправления.Добавить();
		НоваяСтрока.Имя = Расширение.Имя;
		НоваяСтрока.КонтрольнаяСумма = Base64Строка(Расширение.ХешСумма);
		НоваяСтрока.ИдентификаторРасширения = Расширение.УникальныйИдентификатор;
		НоваяСтрока.Версия = Расширение.Версия;
		Если СвойстваИсправления <> Неопределено Тогда
			НоваяСтрока.Статус = 0;
			НоваяСтрока.Описание = СвойстваИсправления.Description;
			НоваяСтрока.ПрименимоДля = ИсправлениеПрименимоДля(СвойстваИсправления);
		Иначе
			НоваяСтрока.Статус = 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ИсправлениеПрименимоДля(СвойстваИсправления)
	
	ПрименимоДля = Новый Массив;
	Для Каждого Строка Из СвойстваИсправления.AppliedFor Цикл
		ПрименимоДля.Добавить(Строка.ConfigurationName);
	КонецЦикла;
	
	Возврат СтрСоединить(ПрименимоДля, Символы.ПС);
	
КонецФункции

&НаКлиенте
Процедура УдалитьРасширения(ВыделенныеСтроки)
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторыРасширений = Новый Массив;
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		СтрокаИсправления = УстановленныеИсправления.НайтиПоИдентификатору(ИдентификаторСтроки);
		ИдентификаторыРасширений.Добавить(СтрокаИсправления.ИдентификаторРасширения);
	КонецЦикла;
	
	Контекст = Новый Структура;
	Контекст.Вставить("ИдентификаторыРасширений", ИдентификаторыРасширений);
	
	Оповещение = Новый ОписаниеОповещения("УдалитьРасширениеПослеПодтверждения", ЭтотОбъект, Контекст);
	Если ИдентификаторыРасширений.Количество() > 1 Тогда
		ТекстВопроса = НСтр("ru = 'Удалить выделенные исправления?'", "ru");
	Иначе
		ТекстВопроса = НСтр("ru = 'Удалить исправление?'", "ru");
	КонецЕсли;
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПослеПодтверждения(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Обработчик = Новый ОписаниеОповещения("УдалитьРасширениеПродолжение", ЭтотОбъект, Контекст);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
			Запросы = ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(Контекст.ИдентификаторыРасширений);
			МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
			МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, ЭтотОбъект, Обработчик);
		Иначе
			ВыполнитьОбработкуОповещения(Обработчик, КодВозвратаДиалога.ОК);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеПродолжение(Результат, Контекст) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ТекущийКонтекст = Контекст;
		ПодключитьОбработчикОжидания("УдалитьРасширениеЗавершение", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширениеЗавершение()
	
	Контекст = ТекущийКонтекст;
	
	Попытка
		УдалитьРасширенияНаСервере(Контекст.ИдентификаторыРасширений);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьРасширенияНаСервере(ИдентификаторыРасширений)
	
	ТекстОшибки = "";
	Справочники.ВерсииРасширений.УдалитьРасширения(ИдентификаторыРасширений, ТекстОшибки);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ОбновитьСписокИсправлений();
	
КонецПроцедуры

&НаСервере
Функция ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(ИдентификаторыРасширений)
	
	Возврат Справочники.ВерсииРасширений.ЗапросыНаОтменуРазрешенийИспользованияВнешнегоМодуля(ИдентификаторыРасширений);
	
КонецФункции

&НаКлиенте
Процедура ПослеУстановкиИсправлений(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьСписокИсправлений();
КонецПроцедуры

#КонецОбласти