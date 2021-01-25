///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Параметры формы:
//     Уровень                           - Число - Запрашиваемый уровень.
//     Родитель                          - УникальныйИдентификатор - Родительский объект.
//     СкрыватьНеактуальныеАдреса        - Булево - флаг того, что при неактуальные адреса будут скрываться.
//     ФорматАдреса - Строка - вариант классификатора.
//     Идентификатор                     - УникальныйИдентификатор - Текущий адресный элемент.
//     Представление                     - Строка - Представление текущего элемента,. используется если не указан
//                                                  Идентификатор.
//
// Результат выбора:
//     Структура - с полями
//         * Отказ                      - Булево - флаг того, что при обработке произошла ошибка.
//         * КраткоеПредставлениеОшибки - Строка - Описание ошибки.
//         * Идентификатор              - УникальныйИдентификатор - Данные адреса.
//         * Представление              - Строка                  - Данные адреса.
//         * РегионЗагружен             - Булево                  - Имеет смысл только для регионов, Истина, если есть
//                                                                  записи.
// ---------------------------------------------------------------------------------------------------------------------
//
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("Родитель", Родитель);
	Параметры.Свойство("Уровень",  Уровень);
	
	Параметры.Свойство("ТипАдреса", ТипАдреса);
	Параметры.Свойство("СкрыватьНеактуальные", СкрыватьНеактуальные);
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("КоличествоЗаписей", 7000);
	
	Если НЕ ЗначениеЗаполнено(Родитель) И Уровень > 1 Тогда
		// поиск адреса без родителя 
		КраткоеПредставлениеОшибки = НСтр("ru = 'Поле не содержит адресных сведений для выбора.'");
		Возврат;
	КонецЕсли;
	
	ДанныеКлассификатора = ДанныеКлассификатораПоИдентификатору(ПараметрыПоиска);
	Если ДанныеКлассификатора.Отказ Тогда
		КраткоеПредставлениеОшибки = ДанныеКлассификатора.КраткоеПредставлениеОшибки;
		Возврат;
	КонецЕсли;
	
	ВариантыАдреса.Загрузить(ДанныеКлассификатора.Данные);
	Заголовок = ДанныеКлассификатора.Заголовок;
	
	// Текущая строка
	ТекущееЗначение = Неопределено;
	Кандидаты       = Неопределено;
	
	Параметры.Свойство("Идентификатор", ТекущееЗначение);
	Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Кандидаты = ВариантыАдреса.НайтиСтроки( Новый Структура("Идентификатор", ТекущееЗначение));
	Иначе
		Параметры.Свойство("Представление", ТекущееЗначение);
		Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
			Кандидаты = ВариантыАдреса.НайтиСтроки( Новый Структура("Представление", ТекущееЗначение));
		КонецЕсли;
	КонецЕсли;
	
	Если Кандидаты <> Неопределено И Кандидаты.Количество() > 0 Тогда
		Элементы.ВариантыАдреса.ТекущаяСтрока = Кандидаты[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
		Элементы.Переместить(Элементы.ВариантыАдресаОбновить, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ВариантыАдресаКонтекстноеМенюНайти, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ВариантыАдресаКонтекстноеМенюОтменитьПоиск, Элементы.ФормаКоманднаяПанель);
		Элементы.Переместить(Элементы.ВариантыАдресаСправка, Элементы.ФормаКоманднаяПанель);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Выбрать", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ВариантыАдресаКонтекстноеМенюГруппаНайти", "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КраткоеПредставлениеОшибки) Тогда
		ОповеститьВладельца(Неопределено, Истина);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантыАдресаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ПроизвестиВыбор(Значение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроизвестиВыбор(Знач НомерСтроки)
	
	Данные = ВариантыАдреса.НайтиПоИдентификатору(НомерСтроки);
	Если Данные = Неопределено Тогда
		Возврат;
		
	ИначеЕсли Не Данные.Неактуален Тогда
		ОповеститьВладельца(Данные);
		Возврат;
		
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроизвестиВыборЗавершениеВопроса", ЭтотОбъект, Данные);
	
	ПредупреждениеНеактуальности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Адрес ""%1"" неактуален.
		           |Продолжить?'"), Данные.Представление);
		
	ЗаголовокПредупреждения = НСтр("ru = 'Подтверждение'");
	
	ПоказатьВопрос(Оповещение, ПредупреждениеНеактуальности, РежимДиалогаВопрос.ДаНет, , ,ЗаголовокПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыборЗавершениеВопроса(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОповеститьВладельца(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца(Знач Данные, Отказ = Ложь)
	
	Результат = КонструкторРезультатаВыбора();
	
	Если Данные <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, Данные);
	Иначе
		Результат.Отказ = Истина;
		Результат.Уровень = Уровень;
		Если Уровень = 7 Тогда
			Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Данные о улицах для введенного адреса отсутствуют'");
		Иначе
			Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Поле не содержит адресных сведений для выбора.'");
		КонецЕсли;
	КонецЕсли;
	
	Результат.Муниципальный = РаботаСАдресамиКлиентСервер.ЭтоМуниципальныйАдрес(ТипАдреса);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторРезультатаВыбора()
	
	Результат = Новый Структура();
	Результат.Вставить("РегионЗагружен",                   Неопределено);
	Результат.Вставить("Идентификатор",                    "");
	Результат.Вставить("Представление",                    "");
	Результат.Вставить("КраткоеПредставлениеОшибки",       "");
	Результат.Вставить("Отказ",                            Ложь);
	Результат.Вставить("Уровень",                          0);
	Результат.Вставить("Муниципальный",                    Неопределено);
	Результат.Вставить("ПредлагатьЗагрузкуКлассификатора", Ложь);
	Результат.Вставить("Родитель",                         Родитель);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВариантыАдресаПредставление.Имя);
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантыАдреса.Неактуален");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиОчистка(Элемент, СтандартнаяОбработка)
	Элементы.ВариантыАдреса.ОтборСтрок = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура НайтиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		Фильтр = Новый ФиксированнаяСтруктура("Представление", Текст);
		Элементы.ВариантыАдреса.ОтборСтрок = Фильтр;
	Иначе
		Элементы.ВариантыАдреса.ОтборСтрок = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ДанныеКлассификатораПоИдентификатору(Знач ПараметрыПоиска)
	
	Результат = Новый Структура();
	Результат.Вставить("Данные", Новый ТаблицаЗначений);
	Результат.Вставить("Заголовок", "");
	Результат.Вставить("КраткоеПредставлениеОшибки", НСтр("ru = 'Поле не содержит адресных сведений для выбора'"));
	Результат.Вставить("Отказ", Ложь);
	
	ДанныеКлассификатора = Обработки.РасширенныйВводКонтактнойИнформации.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ТипАдреса, ПараметрыПоиска);
	
	Если ДанныеКлассификатора.Отказ Тогда
		// Сервис на обслуживании
		Результат.КраткоеПредставлениеОшибки = НСтр("ru = 'Автоподбор и проверка адреса недоступны:'") + Символы.ПС + ДанныеКлассификатора.КраткоеПредставлениеОшибки;
		Результат.Отказ = Истина;
		Возврат Результат;
		
	ИначеЕсли ДанныеКлассификатора.Данные.Количество() = 0 Тогда
		
		НаименованиеРегиона = РаботаСАдресами.РегионАдресаКонтактнойИнформации(РаботаСАдресами.АдресПоИдентификатору(Родитель));
		Если РаботаСАдресами.ЭтоГородФедеральногоЗначения(НаименованиеРегиона) Тогда
			
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
				
				Сведения = Новый Структура();
				Сведения.Вставить("Идентификатор", Родитель);
				
				МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
				ПолученныеАдрес = МодульАдресныйКлассификаторСлужебный.АктуальныеАдресныеСведения(Сведения);
				
				Если ПолученныеАдрес.Отказ Тогда
					Результат.Отказ = Истина;
					Возврат Результат;
				КонецЕсли;
				
				Адрес = ПолученныеАдрес.Данные;
				Родитель = Адрес.areaId;
				
				ДанныеКлассификатора = Обработки.РасширенныйВводКонтактнойИнформации.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ТипАдреса, ПараметрыПоиска);
				
				Если ДанныеКлассификатора.Данные.Количество() = 0 Тогда
					Результат.Отказ = Истина;
					Возврат Результат;
				КонецЕсли;
			Иначе
				
				Результат.Отказ = Истина;
				Возврат Результат;
				
			КонецЕсли;
		Иначе
			Результат.Отказ = Истина;
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	
	Результат.Данные = ДанныеКлассификатора.Данные;
	Результат.Заголовок = ДанныеКлассификатора.Заголовок;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
