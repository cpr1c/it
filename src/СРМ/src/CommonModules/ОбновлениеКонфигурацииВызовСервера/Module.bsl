///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверка наличия активных соединений с информационной базой.
//
// Возвращаемое значение:
//  Булево       - Истина, если соединения есть,
//                 Ложь, если соединений нет.
Функция НаличиеАктивныхСоединений(СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	// Запись накопленных событий ЖР.
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	Возврат СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь, Ложь) > 1;
КонецФункции

Процедура ЗаписатьСтатусОбновления(ИмяАдминистратораОбновления, ОбновлениеЗапланировано, ОбновлениеВыполнено,
	РезультатОбновления, ИмяФайлаСкрипта = "", СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	КаталогСкрипта = "";
	
	Если Не ПустаяСтрока(ИмяФайлаСкрипта) Тогда 
		КаталогСкрипта = Лев(ИмяФайлаСкрипта, СтрДлина(ИмяФайлаСкрипта) - 10);
	КонецЕсли;
	
	ОбновлениеКонфигурации.ЗаписатьСтатусОбновления(
		ИмяАдминистратораОбновления,
		ОбновлениеЗапланировано,
		ОбновлениеВыполнено,
		РезультатОбновления,
		КаталогСкрипта,
		СообщенияДляЖурналаРегистрации);
	
КонецПроцедуры

Функция ТекстыМакетов(ИнтерактивныйРежим, СообщенияДляЖурналаРегистрации, ВыполнитьОтложенныеОбработчики, ЭтоОтложенноеОбновление) Экспорт
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	ТекстыМакетов = Новый Структура;
	ТекстыМакетов.Вставить("ДопФайлОбновленияКонфигурации");
	ТекстыМакетов.Вставить(?(ИнтерактивныйРежим, "ЗаставкаОбновленияКонфигурации", "НеинтерактивноеОбновлениеКонфигурации"));
	
	Если ЭтоОтложенноеОбновление Тогда
		ТекстыМакетов.Вставить("СкриптСозданияЗадачиПланировщикаЗадач");
	КонецЕсли;
	
	ТекстыМакетов.Вставить("СкриптУдаленияПатчей");
	
	Для Каждого СвойстваМакета Из ТекстыМакетов Цикл
		ТекстыМакетов[СвойстваМакета.Ключ] = Обработки.УстановкаОбновлений.ПолучитьМакет(СвойстваМакета.Ключ).ПолучитьТекст();
	КонецЦикла;
	
	// Файл обновления конфигурации: main.js.
	ШаблонСкрипта = Обработки.УстановкаОбновлений.ПолучитьМакет("МакетФайлаОбновленияКонфигурации");
	
	ОбластьПараметров = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	ОбластьПараметров.УдалитьСтроку(1);
	ОбластьПараметров.УдалитьСтроку(ОбластьПараметров.КоличествоСтрок());
	ТекстыМакетов.Вставить("ОбластьПараметров", ОбластьПараметров.ПолучитьТекст());
	
	ОбластьОбновленияКонфигурации = ШаблонСкрипта.ПолучитьОбласть("ОбластьОбновленияКонфигурации");
	ОбластьОбновленияКонфигурации.УдалитьСтроку(1);
	ОбластьОбновленияКонфигурации.УдалитьСтроку(ОбластьОбновленияКонфигурации.КоличествоСтрок());
	ТекстыМакетов.Вставить("МакетФайлаОбновленияКонфигурации", ОбластьОбновленияКонфигурации.ПолучитьТекст());
	
	// Запись накопленных событий ЖР.
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	ВыполнитьОтложенныеОбработчики = ОбновлениеКонфигурации.ВыполнитьОтложенныеОбработчики();
	
	Возврат ТекстыМакетов;
	
КонецФункции

Процедура СохранитьНастройкиОбновленияКонфигурации(Настройки) Экспорт
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	ОбновлениеКонфигурации.СохранитьНастройкиОбновленияКонфигурации(Настройки);
КонецПроцедуры

#КонецОбласти
