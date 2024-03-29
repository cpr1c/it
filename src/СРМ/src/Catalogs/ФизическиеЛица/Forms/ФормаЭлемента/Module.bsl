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
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ГиперссылкаФайлов = РаботаСФайлами.ГиперссылкаФайлов();
	ГиперссылкаФайлов.Размещение = "КоманднаяПанель";
	
	ПараметрыПоля                           = РаботаСФайлами.ПолеФайла();
	ПараметрыПоля.Размещение                = "ГруппаФотография";
	ПараметрыПоля.ПутьКДанным               = "Объект.Фотография";
	ПараметрыПоля.ОчищатьФайл               = Ложь;
	ПараметрыПоля.ВыбиратьФайл              = Ложь;
	ПараметрыПоля.ДобавлятьФайлы            = Ложь;
	ПараметрыПоля.ПросматриватьФайл         = Ложь;
	ПараметрыПоля.РедактироватьФайл         = Ложь;
	ПараметрыПоля.ПоказыватьКоманднуюПанель = Ложь;
	
	ДобавляемыеЭлементы = Новый Массив;
	ДобавляемыеЭлементы.Добавить(ГиперссылкаФайлов);
	ДобавляемыеЭлементы.Добавить(ПараметрыПоля);
	
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ДобавляемыеЭлементы);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	Если Параметры.Свойство("Партнер") Тогда
		Если ТипЗнч(Параметры.Партнер) = Тип("СправочникСсылка.Проекты") Тогда
			Партнер = Параметры.Партнер.Партнер;
		Иначе
			Партнер=Параметры.Партнер;
		КонецЕсли;
		ЗаполнитьПартнеровФизическогоЛица();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьПартнеровФизическогоЛица();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
		
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ЗаполнитьПараметрыСклонения(ЭтотОбъект, ПараметрыСклонения);
	СклонениеПредставленийОбъектов.ПриЗаписиФормыОбъектаСклонения(ЭтотОбъект, Объект.Наименование, ТекущийОбъект.Ссылка, ПараметрыСклонения);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

	Если ЗначениеЗаполнено(Партнер) И Не Отказ Тогда
		ФизическиеЛицаСервер.ДобавитьСвязанногоПартнераКФизЛицу(ТекущийОбъект.Ссылка, Партнер);
		ЗаполнитьПартнеровФизическогоЛица();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ФизическиеЛица", Новый Структура, Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ЗаполнитьПараметрыСклонения(ЭтотОбъект, ПараметрыСклонения);
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(ЭтотОбъект, Объект.Наименование, ПараметрыСклонения);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)

	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

//@skip-warning
&НаКлиенте
Процедура Подключаемый_УдалениеСвязанногоПартнера(Команда)
	ИдентфикаторПартнера=СтрЗаменить(Команда.Имя, "ПартнерФизЛица_", "");
	ИдентфикаторПартнера=СтрЗаменить(ИдентфикаторПартнера, "_Удалить", "");
	ИдентфикаторПартнера=СтрЗаменить(ИдентфикаторПартнера, "_", "-");
	УдалитьСвязанногоПартнера(ИдентфикаторПартнера);
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) Экспорт
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте
Процедура Склонения(Команда)
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ЗаполнитьПараметрыСклонения(ЭтотОбъект, ПараметрыСклонения);
	СклонениеПредставленийОбъектовКлиент.ПоказатьСклонение(ЭтотОбъект, Объект.Наименование, ПараметрыСклонения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПараметрыСклонения(Форма, ПараметрыСклонения)
	
	ПараметрыСклонения.ЭтоФИО = Истина;
	ПараметрыСклонения.Пол = Неопределено;
	
	Если ЗначениеЗаполнено(Форма.Объект.Пол) Тогда
		ПараметрыСклонения.Пол = 1;
		Если Форма.Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Женский") Тогда
			ПараметрыСклонения.Пол = 2;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСвязанногоПартнера(Команда)

	ОткрытьФорму("Справочник.Партнеры.Форма.ФормаВыбора", Новый Структура, ЭтаФорма, , , ,
		Новый ОписаниеОповещения("ДобавитьСвязанногоПартнераЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

КонецПроцедуры


#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции


&НаКлиенте
Процедура ДобавитьСвязанногоПартнераЗавершение(Результат1, ДополнительныеПараметры) Экспорт

	Результат=Результат1;

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ФизическиеЛицаСервер.ДобавитьСвязанногоПартнераКФизЛицу(Объект.Ссылка, Результат);

	ЗаполнитьПартнеровФизическогоЛица();
КонецПроцедуры


&НаСервере
Процедура УдалитьСвязанногоПартнера(ИдентификаторПартнера)

	СвязаннаяПартнер=Справочники.Партнеры.ПолучитьСсылку(
		Новый УникальныйИдентификатор(ИдентификаторПартнера));

	ФизическиеЛицаСервер.УдалитьСвязанногоПартнераФизЛица(Объект.Ссылка, СвязаннаяПартнер);
	
	ЗаполнитьПартнеровФизическогоЛица();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПартнеровФизическогоЛица()
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не ЗначениеЗаполнено(Партнер) Тогда
			Возврат;
		КонецЕсли;
		МассивПартнеров=Новый Массив;
		МассивПартнеров.Добавить(Партнер);
	Иначе
		МассивПартнеров=ФизическиеЛицаСервер.ПартнерыФизическогоЛица(Объект.Ссылка);
	КонецЕсли;

	МассивДобавляемыхРеквизитов=Новый Массив;
	МассивИменДобавляемыхРеквизитов=Новый Массив;
	МассивУдаляемыхРеквизитов=Новый Массив;

	Реквизиты=ПолучитьРеквизиты("");

	МассивТекущихРеквизитов=Новый Массив;
	МассивИменТекущихРеквизитов=Новый Массив;
	ДанныеПартнеров=Новый Соответствие;

	ПрефикРеквизитов="ПартнерФизЛица_";

	Для Каждого ТекРеквизит Из Реквизиты Цикл
		Если СтрНайти(ТекРеквизит.Имя, ПрефикРеквизитов) = 1 Тогда
			МассивТекущихРеквизитов.Добавить(ТекРеквизит);
			МассивИменТекущихРеквизитов.Добавить(ТекРеквизит.Имя);
		КонецЕсли;
	КонецЦикла;

	Для Каждого ТекПартнер Из МассивПартнеров Цикл
		ИмяРеквизита=ПрефикРеквизитов + СтрЗаменить(ТекПартнер.УникальныйИдентификатор(), "-",
			"_");
		МассивИменДобавляемыхРеквизитов.Добавить(ИмяРеквизита);
		ДанныеПартнеров.Вставить(ИмяРеквизита, ТекПартнер);
		Если МассивИменТекущихРеквизитов.Найти(ИмяРеквизита) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Реквизит=Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("СправочникСсылка.Партнеры"), "", "", Истина);
		МассивДобавляемыхРеквизитов.Добавить(Реквизит);
	КонецЦикла;

	Для Каждого ИмяРеквизита Из МассивИменТекущихРеквизитов Цикл
		Если МассивИменДобавляемыхРеквизитов.Найти(ИмяРеквизита) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		МассивУдаляемыхРеквизитов.Добавить(ИмяРеквизита);
	КонецЦикла;

	ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, МассивУдаляемыхРеквизитов);

	Для Каждого Реквизит Из МассивДобавляемыхРеквизитов Цикл
		//Группа для задачи
		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя + "_Группа";
		ОписаниеЭлемента.РодительЭлемента=Элементы.ГруппаПартнеры;
		//ОписаниеЭлемента.Заголовок="Редатирование";		

		ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид", ВидГруппыФормы.ОбычнаяГруппа);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина", Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота", Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		//ОписаниеЭлемента.Параметры.Вставить("ЦветФона",WebЦвета.БледноБирюзовый);
		ОписаниеЭлемента.Параметры.Вставить("Отображение", ОтображениеОбычнойГруппы.Нет);
		ОписаниеЭлемента.Параметры.Вставить("Группировка", ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда);
		ОписаниеЭлемента.Параметры.Вставить("ОтображатьЗаголовок", Ложь);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали", Истина);

		ГруппаЗадачи=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма, ОписаниеЭлемента);

		ОписаниеЭлемента=РаботаСФормамиСервер.НовыйОписаниеРеквизитаЭлемента();
		ОписаниеЭлемента.Имя=Реквизит.Имя;
		ОписаниеЭлемента.РодительЭлемента=ГруппаЗадачи;
		//ОписаниеЭлемента.Заголовок="Редатирование";		
		
		//ОписаниеЭлемента.Параметры.Тип=Тип("ГруппаФормы");
		ОписаниеЭлемента.Параметры.Вставить("Вид", ВидПоляФормы.ПолеНадписи);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяШирина", Ложь);
		ОписаниеЭлемента.Параметры.Вставить("АвтоМаксимальнаяВысота", Ложь);
		ОписаниеЭлемента.Параметры.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
		ОписаниеЭлемента.Параметры.Вставить("Гиперссылка", Истина);
		//ОписаниеЭлемента.Параметры.Вставить("АвтоВысотаЯчейки",Истина);
		ОписаниеЭлемента.Параметры.Вставить("РастягиватьПоВертикали", Истина);
		//ОписаниеЭлемента.Параметры.Вставить("Рамка",Истина);
		ОписаниеЭлемента.Параметры.Вставить("ВертикальноеПоложение", ВертикальноеПоложениеЭлемента.Верх);

		ЭлементЗадачи=РаботаСФормамиСервер.СоздатьЭлементПоОписанию(ЭтаФорма, ОписаниеЭлемента);
		//ЭлементЗадачи.ВертикальноеПоложение=ВертикальноеПоложениеЭлемента.Верх;
		//ЭлементЗадачи.Рамка=новый Рамка(ТипРамкиЭлементаУправления.Одинарная,1);
		
		//Кнопка удаления
		НовыйОписаниеКомандыКнопки=РаботаСФормамиСервер.НовыйОписаниеКомандыКнопки();
		НовыйОписаниеКомандыКнопки.Имя=Реквизит.Имя + "_Удалить";
		НовыйОписаниеКомандыКнопки.Действие="Подключаемый_УдалениеСвязанногоПартнера";
		НовыйОписаниеКомандыКнопки.ИмяКоманды=НовыйОписаниеКомандыКнопки.Имя;
		НовыйОписаниеКомандыКнопки.Заголовок="Удалить";
		НовыйОписаниеКомандыКнопки.Картинка=БиблиотекаКартинок.УдалитьНепосредственно;
		НовыйОписаниеКомандыКнопки.РодительЭлемента=ГруппаЗадачи;
		//НовыйОписаниеКомандыКнопки.СочетаниеКлавиш=СочетаниеКлавиш;

		КомандаФормы=РаботаСФормамиСервер.СоздатьКомандуПоОписанию(ЭтаФорма, НовыйОписаниеКомандыКнопки);
		КомандаФормы.Отображение=ОтображениеКнопки.Картинка;
		РаботаСФормамиСервер.СоздатьКнопкуПоОписанию(ЭтаФорма, НовыйОписаниеКомандыКнопки);

		ЭтаФорма[Реквизит.Имя]=ДанныеПартнеров[Реквизит.Имя];

	КонецЦикла;

	Для Каждого УдаляемыйРеквизит Из МассивУдаляемыхРеквизитов Цикл
		Элементы.Удалить(Элементы[УдаляемыйРеквизит + "_Группа"]);
	КонецЦикла;

	Элементы.ГруппаПартнеры.Заголовок="Связанные партнеры" + ?(МассивПартнеров.Количество() = 0, "", "("
		+ МассивПартнеров.Количество() + ")");
	Элементы.ГруппаПартнеры.ЗаголовокСвернутогоОтображения="Связанные партнеры" + ?(
		МассивПартнеров.Количество() = 0, "", "(" + МассивПартнеров.Количество() + ")");
КонецПроцедуры



#КонецОбласти