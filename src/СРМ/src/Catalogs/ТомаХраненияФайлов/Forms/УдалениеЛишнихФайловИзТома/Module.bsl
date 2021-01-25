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
	
	Параметры.Свойство("ТомХраненияФайлов", ТомХраненияФайлов);
	
	ЗаполнитьТаблицуЛишнихФайлов();
	КоличествоЛишнихФайлов = ЛишниеФайлы.Количество();
	
	ПутьДня = Формат(ТекущаяДатаСеанса(), "ДФ=ггггММдд") + ПолучитьРазделительПути();
	
	СкопироватьФайлыПередУдалением                = Ложь;
	Элементы.ПутьКПапкеДляКопирования.Доступность = Ложь;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПодробнееНажатие(Элемент)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	ПараметрыОтчета.Вставить("Отбор", Новый Структура("Том", ТомХраненияФайлов));
	
	ОткрытьФорму("Отчет.ПроверкаЦелостностиТома.ФормаОбъекта", ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПапкеДляКопированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Каталог = ПутьКПапкеДляКопирования;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = Заголовок;
	
	Контекст = Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла);
	
	ОписаниеОповещенияДиалогаВыбора = Новый ОписаниеОповещения(
		"ПутьКПапкеДляКопированияНачалоВыбораЗавершение", ЭтотОбъект, Контекст);
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещенияДиалогаВыбора, ДиалогОткрытияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПапкеДляКопированияНачалоВыбораЗавершение(ВыбранныеФайлы, Контекст) Экспорт
	
	ДиалогОткрытияФайла = Контекст.ДиалогОткрытияФайла;
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Элементы.ФормаУдалитьЛишниеФайлы.Доступность = Ложь;
	Иначе
		ПутьКПапкеДляКопирования = ДиалогОткрытияФайла.Каталог;
		ПутьКПапкеДляКопирования = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКПапкеДляКопирования);
		Элементы.ФормаУдалитьЛишниеФайлы.Доступность = ЗначениеЗаполнено(ПутьКПапкеДляКопирования);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПутьКПапкеДляКопированияПриИзменении(Элемент)
	
	ПутьКПапкеДляКопирования                     = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКПапкеДляКопирования);
	Элементы.ФормаУдалитьЛишниеФайлы.Доступность = ЗначениеЗаполнено(ПутьКПапкеДляКопирования);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьФайлыПередУдалениемПриИзменении(Элемент)
	
	Если Не СкопироватьФайлыПередУдалением Тогда
		ПутьКПапкеДляКопирования                      = "";
		Элементы.ПутьКПапкеДляКопирования.Доступность = Ложь;
		Элементы.ФормаУдалитьЛишниеФайлы.Доступность  = Истина;
	Иначе
		Элементы.ПутьКПапкеДляКопирования.Доступность = Истина;
		Если ЗначениеЗаполнено(ПутьКПапкеДляКопирования) Тогда
			Элементы.ФормаУдалитьЛишниеФайлы.Доступность = Истина;
		Иначе
			Элементы.ФормаУдалитьЛишниеФайлы.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УдалитьЛишниеФайлы(Команда)
	
	Если КоличествоЛишнихФайлов = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Нет ни одного лишнего файла на диске'"));
		Возврат;
	КонецЕсли;
	
	ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(
		Новый ОписаниеОповещения("ПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект),, 
		Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если Не РасширениеПодключено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Расширение работы с файлами не установлено. Работа с файлами с неустановленным расширением в веб клиенте невозможна.'"));
		Возврат;
	КонецЕсли;
	
	Если Не СкопироватьФайлыПередУдалением Тогда
		ПослеПроверкиЗаписиВКаталог(Истина, Новый Структура);
	Иначе
		ПапкаДляКопирования = Новый Файл(ПутьКПапкеДляКопирования);
		ПапкаДляКопирования.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияКаталогаЗавершение", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияКаталогаЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	Если Не Существует Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Путь к каталогу копирования некорректен.'"));
	Иначе
		ПравоЗаписиВКаталог(Новый ОписаниеОповещения("ПослеПроверкиЗаписиВКаталог", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиЗаписиВКаталог(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	Если ЛишниеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИтоговогоОповещения = Новый Структура;
	ПараметрыИтоговогоОповещения.Вставить("МассивФайловСОшибками", Новый Массив);
	ПараметрыИтоговогоОповещения.Вставить("ЧислоУдаленныхФайлов",  0);
	ИтоговоеОповещение = Новый ОписаниеОповещения("ПослеОбработкиФайлов", ЭтотОбъект, ПараметрыИтоговогоОповещения);
	
	ВыполнитьОбработкуОповещения(Новый ОписаниеОповещения("ОбработатьОчереднойФайл", ЭтотОбъект,
		Новый Структура("ИтоговоеОповещение, ТекущийФайл", ИтоговоеОповещение, Неопределено), "ОбработатьОчереднойФайлОшибка", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОчереднойФайл(Результат, ДополнительныеПараметры) Экспорт
	
	ТекущийФайл       = ДополнительныеПараметры.ТекущийФайл;
	ПоследняяИтерация = Ложь;
	
	Если ТекущийФайл = Неопределено Тогда
		ТекущийФайл = ЛишниеФайлы.Получить(0);
	Иначе
		
		ИндексТекущегоФайла = ЛишниеФайлы.Индекс(ТекущийФайл);
		Если ИндексТекущегоФайла = ЛишниеФайлы.Количество() - 1 Тогда
			ПоследняяИтерация = Истина;
		Иначе
			ТекущийФайл = ЛишниеФайлы.Получить(ИндексТекущегоФайла + 1);
		КонецЕсли;
		
	КонецЕсли;
	
	ПолноеИмяТекущегоФайла = ТекущийФайл.ПолноеИмя;
	КаталогДляКопирования  = ПутьКПапкеДляКопирования + ПутьДня + ПолучитьРазделительПути();
	
	ПараметрыТекущегоФайла = Новый Структура;
	ПараметрыТекущегоФайла.Вставить("ИтоговоеОповещение",    ДополнительныеПараметры.ИтоговоеОповещение);
	ПараметрыТекущегоФайла.Вставить("ТекущийФайл",           ТекущийФайл);
	ПараметрыТекущегоФайла.Вставить("ПоследняяИтерация",     ПоследняяИтерация);
	ПараметрыТекущегоФайла.Вставить("КаталогДляКопирования", КаталогДляКопирования);
	
	Если Не ПустаяСтрока(ПутьКПапкеДляКопирования) Тогда
		
		Файл = Новый Файл(ПолноеИмяТекущегоФайла);
		Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияФайлаЗавершение", ЭтотОбъект, ПараметрыТекущегоФайла));
		
	Иначе
		
		НачатьУдалениеФайлов(Новый ОписаниеОповещения("ОбработатьУдалениеОчередногоФайлаЗавершение", ЭтотОбъект, ПараметрыТекущегоФайла,
			"ОбработатьОчереднойФайлОшибка", ЭтотОбъект), ПолноеИмяТекущегоФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияФайлаЗавершение(ФайлСуществует, ДополнительныеПараметры) Экспорт
	
	Если Не ФайлСуществует Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ИтоговоеОповещение);
	Иначе
		КаталогТекущегоДня = Новый Файл(ДополнительныеПараметры.КаталогДляКопирования);
		КаталогТекущегоДня.НачатьПроверкуСуществования(Новый ОписаниеОповещения("КаталогДняСуществуетЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогДняСуществуетЗавершение(КаталогСуществует, ДополнительныеПараметры) Экспорт
	
	Если Не КаталогСуществует Тогда
		НачатьСозданиеКаталога(Новый ОписаниеОповещения("СоздатьКаталогДняЗавершение", ЭтотОбъект, ДополнительныеПараметры), ДополнительныеПараметры.КаталогДляКопирования);
	Иначе
		КонечноеИмяФайла = ДополнительныеПараметры.КаталогДляКопирования + ДополнительныеПараметры.ТекущийФайл.Имя;
		Файл = Новый Файл(КонечноеИмяФайла);
		Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияКонечногоФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКаталогДняЗавершение(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	КонечноеИмяФайла = ДополнительныеПараметры.КаталогДляКопирования + ДополнительныеПараметры.ТекущийФайл.Имя;
	Файл = Новый Файл(КонечноеИмяФайла);
	Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПроверкаСуществованияКонечногоФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаСуществованияКонечногоФайлаЗавершение(ФайлСуществует, ДополнительныеПараметры) Экспорт
	
	КаталогДляКопирования  = ДополнительныеПараметры.КаталогДляКопирования;
	ИмяТекущегоФайла       = ДополнительныеПараметры.ТекущийФайл.Имя;
	ПолноеИмяТекущегоФайла = ДополнительныеПараметры.ТекущийФайл.ПолноеИмя;
	
	Если Не ФайлСуществует Тогда
		КонечноеИмяФайла = КаталогДляКопирования + ИмяТекущегоФайла;
	Иначе
		РазделенноеИмяФайла = СтрРазделить(ИмяТекущегоФайла, ".");
		ИмяБезРасширения    = РазделенноеИмяФайла.Получить(0);
		Расширение          = РазделенноеИмяФайла.Получить(1);
		КонечноеИмяФайла    = КаталогДляКопирования + ИмяБезРасширения + "_" + Строка(Новый УникальныйИдентификатор) + "." + Расширение;
	КонецЕсли;
		
	НачатьПеремещениеФайла(Новый ОписаниеОповещения("ОбработатьПеремещениеОчередногоФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры,
		"ОбработатьОчереднойФайлОшибка", ЭтотОбъект), ПолноеИмяТекущегоФайла, КонечноеИмяФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПеремещениеОчередногоФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОбработатьОчереднойФайлЗавершение(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьУдалениеОчередногоФайлаЗавершение(ДополнительныеПараметры) Экспорт
	
	ОбработатьОчереднойФайлЗавершение(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОчереднойФайлЗавершение(ДополнительныеПараметры)
	
	ТекущийФайл                  = ДополнительныеПараметры.ТекущийФайл;
	ИтоговоеОповещение           = ДополнительныеПараметры.ИтоговоеОповещение;
	ПараметрыИтоговогоОповещения = ИтоговоеОповещение.ДополнительныеПараметры;
	
	ПараметрыИтоговогоОповещения.Вставить("ЧислоУдаленныхФайлов", ПараметрыИтоговогоОповещения.ЧислоУдаленныхФайлов + 1);
	
	Если ДополнительныеПараметры.ПоследняяИтерация Тогда
		ВыполнитьОбработкуОповещения(ИтоговоеОповещение);
	Иначе
		ВыполнитьОбработкуОповещения(Новый ОписаниеОповещения("ОбработатьОчереднойФайл", ЭтотОбъект,
			Новый Структура("ИтоговоеОповещение, ТекущийФайл", ИтоговоеОповещение, ТекущийФайл), "ОбработатьОчереднойФайлОшибка", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОчереднойФайлОшибка(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	ТекущийФайл      = ДополнительныеПараметры.ТекущийФайл;
	ИмяТекущегоФайла = ТекущийФайл.Имя;
	
	ИтоговоеОповещение           = ДополнительныеПараметры.ИтоговоеОповещение;
	ПараметрыИтоговогоОповещения = ИтоговоеОповещение.ДополнительныеПараметры;
	
	СтруктураОшибки = Новый Структура;
	СтруктураОшибки.Вставить("Имя",    ИмяТекущегоФайла);
	СтруктураОшибки.Вставить("Ошибка", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	
	МассивФайловСОшибками = ПараметрыИтоговогоОповещения.МассивФайловСОшибками;
	МассивФайловСОшибками.Добавить(СтруктураОшибки);
	ПараметрыИтоговогоОповещения.Вставить("МассивФайловСОшибками", МассивФайловСОшибками);
	
	ОбработатьСообщениеОбОшибке(ТекущийФайл.ПолноеИмя, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	
	Если ДополнительныеПараметры.ПоследняяИтерация Тогда
		ВыполнитьОбработкуОповещения(ИтоговоеОповещение);
	Иначе
		ВыполнитьОбработкуОповещения(Новый ОписаниеОповещения("ОбработатьОчереднойФайл", ЭтотОбъект,
			Новый Структура("ИтоговоеОповещение, ТекущийФайл", ИтоговоеОповещение, ТекущийФайл), "ОбработатьОчереднойФайлОшибка", ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбработкиФайлов(Результат, ДополнительныеПараметры) Экспорт
	
	ЧислоУдаленныхФайлов  = ДополнительныеПараметры.ЧислоУдаленныхФайлов;
	МассивФайловСОшибками = ДополнительныеПараметры.МассивФайловСОшибками;
	
	Если ЧислоУдаленныхФайлов <> 0 Тогда
		ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Удалено файлов: %1'"),
			ЧислоУдаленныхФайлов);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Завершено удаление лишних файлов.'"),
			,
			ТекстОповещения,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	Если МассивФайловСОшибками.Количество() > 0 Тогда
		ОтчетОбОшибках = Новый ТабличныйДокумент;
		СформироватьОтчетОбОшибках(ОтчетОбОшибках, МассивФайловСОшибками);
		ОтчетОбОшибках.Показать();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуЛишнихФайлов()
	
	ТаблицаФайловНаДиске = Новый ТаблицаЗначений;
	КолонкиТаблицы       = ТаблицаФайловНаДиске.Колонки;
	КолонкиТаблицы.Добавить("Имя");
	КолонкиТаблицы.Добавить("Файл");
	КолонкиТаблицы.Добавить("ИмяБезРасширения");
	КолонкиТаблицы.Добавить("ПолноеИмя");
	КолонкиТаблицы.Добавить("Путь");
	КолонкиТаблицы.Добавить("Том");
	КолонкиТаблицы.Добавить("Расширение");
	КолонкиТаблицы.Добавить("СтатусПроверки");
	КолонкиТаблицы.Добавить("Количество");
	КолонкиТаблицы.Добавить("Отредактировал");
	КолонкиТаблицы.Добавить("ДатаРедактирования");

	ПутьКТому = РаботаСФайламиСлужебный.ПолныйПутьТома(ТомХраненияФайлов);
	
	МассивФайлов = НайтиФайлы(ПутьКТому,"*", Истина);
	Для Каждого Файл Из МассивФайлов Цикл
		
		Если Не Файл.ЭтоФайл() Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаФайловНаДиске.Добавить();
		НоваяСтрока.Имя              = Файл.Имя;
		НоваяСтрока.ИмяБезРасширения = Файл.ИмяБезРасширения;
		НоваяСтрока.ПолноеИмя        = Файл.ПолноеИмя;
		НоваяСтрока.Путь             = Файл.Путь;
		НоваяСтрока.Расширение       = Файл.Расширение;
		НоваяСтрока.СтатусПроверки   = НСтр("ru = 'Лишние файлы (есть на диске, но сведения о них отсутствуют)'");
		НоваяСтрока.Количество       = 1;
		НоваяСтрока.Том              = ТомХраненияФайлов;
		
	КонецЦикла;
	
	РаботаСФайламиСлужебный.ПроверитьЦелостностьФайлов(ТаблицаФайловНаДиске, ТомХраненияФайлов);
	ТаблицаФайловНаДиске.Индексы.Добавить("СтатусПроверки");
	МассивЛишнихФайлов = ТаблицаФайловНаДиске.НайтиСтроки(
		Новый Структура("СтатусПроверки", НСтр("ru = 'Лишние файлы (есть на диске, но сведения о них отсутствуют)'")));
	
	Для Каждого Файл Из МассивЛишнихФайлов Цикл
		НоваяСтрока = ЛишниеФайлы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Файл);
	КонецЦикла;
	
	ЛишниеФайлы.Сортировать("Имя");
	
КонецПроцедуры

&НаКлиенте
Процедура ПравоЗаписиВКаталог(ИсходноеОповещение)
	
	Если ПустаяСтрока(ПутьКПапкеДляКопирования) Тогда
		ВыполнитьОбработкуОповещения(ИсходноеОповещение, Истина);
		Возврат
	КонецЕсли;
	
	ИмяКаталога = ПутьКПапкеДляКопирования + "ПроверкаДоступа\";
	
	ПараметрыУдаленияКаталога  = Новый Структура("ИсходноеОповещение, ИмяКаталога", ИсходноеОповещение, ИмяКаталога);
	ОповещениеСозданияКаталога = Новый ОписаниеОповещения("ПослеСозданияКаталога", ЭтотОбъект, ПараметрыУдаленияКаталога, "ПослеОшибкиСозданияКаталога", ЭтотОбъект);
	НачатьСозданиеКаталога(ОповещениеСозданияКаталога, ИмяКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОшибкиСозданияКаталога(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	ОбработатьОшибкуПравДоступа(ИнформацияОбОшибке, ДополнительныеПараметры.ИсходноеОповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСозданияКаталога(Результат, ДополнительныеПараметры) Экспорт
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПослеУдаленияКаталога", ЭтотОбъект, ДополнительныеПараметры, "ПослеОшибкиУдаленияКаталога", ЭтотОбъект), ДополнительныеПараметры.ИмяКаталога);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияКаталога(ДополнительныеПараметры) Экспорт
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ИсходноеОповещение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОшибкиУдаленияКаталога(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	ОбработатьОшибкуПравДоступа(ИнформацияОбОшибке, ДополнительныеПараметры.ИсходноеОповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОшибкуПравДоступа(ИнформацияОбОшибке, ИсходноеОповещение)
	
	ШаблонОшибки = НСтр("ru = 'Путь каталога для копирования некорректен.
	|Возможно учетная запись, от лица которой работает
	|сервер 1С:Предприятия, не имеет прав доступа к указанному каталогу.
	|
	|%1'");
	
	ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , , "ПутьКПапкеДляКопирования");
	
	ВыполнитьОбработкуОповещения(ИсходноеОповещение, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщениеОбОшибке(ИмяФайла, ИнформацияОбОшибке)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Файлы.Ошибка удаления лишних файлов'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,,,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При удалении файла с диска
				|""%1""
				|возникла ошибка:
				|""%2"".'"),
			ИмяФайла,
			ИнформацияОбОшибке));
		
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетОбОшибках(ОтчетОбОшибках, МассивФайловСОшибками)
	
	ТабМакет = Справочники.ТомаХраненияФайлов.ПолучитьМакет("МакетОтчета");
	
	ОбластьЗаголовок = ТабМакет.ПолучитьОбласть("Заголовок");
	ОбластьЗаголовок.Параметры.Описание = НСтр("ru = 'Файлы с ошибками:'");
	ОтчетОбОшибках.Вывести(ОбластьЗаголовок);
	
	ОбластьСтрока = ТабМакет.ПолучитьОбласть("Строка");
	
	Для Каждого ФайлСОшибкой Из МассивФайловСОшибками Цикл
		ОбластьСтрока.Параметры.Название = ФайлСОшибкой.Имя;
		ОбластьСтрока.Параметры.Ошибка = ФайлСОшибкой.Ошибка;
		ОтчетОбОшибках.Вывести(ОбластьСтрока);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти