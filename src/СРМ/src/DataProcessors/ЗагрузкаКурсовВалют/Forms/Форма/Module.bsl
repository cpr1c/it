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

	УстановитьУсловноеОформление();
	
	Если НЕ Параметры.Свойство("ОткрытиеИзСписка") Тогда
		Если РаботаСКурсамиВалют.КурсыАктуальны() Тогда
			СообщитьЧтоКурсыАктуальны = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьВалюты();
	
	// Начало и окончание периода загрузки курсов.
	Объект.ОкончаниеПериодаЗагрузки = НачалоДня(ТекущаяДатаСеанса());
	Объект.НачалоПериодаЗагрузки = Объект.ОкончаниеПериодаЗагрузки;
	МинимальнаяДата = НачалоГода(Объект.ОкончаниеПериодаЗагрузки);
	Для Каждого Валюта Из Объект.СписокВалют Цикл
		Если ЗначениеЗаполнено(Валюта.ДатаКурса) И Валюта.ДатаКурса < Объект.НачалоПериодаЗагрузки Тогда
			Если Валюта.ДатаКурса < МинимальнаяДата Тогда
				Объект.НачалоПериодаЗагрузки = МинимальнаяДата;
				Прервать;
			КонецЕсли;
			Объект.НачалоПериодаЗагрузки = Валюта.ДатаКурса;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СообщитьЧтоКурсыАктуальны Тогда
		РаботаСКурсамиВалютКлиент.ОповеститьКурсыАктуальны();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьСписокЗагружаемыхВалют", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВалют

&НаКлиенте
Процедура СписокВалютВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПереключитьЗагрузку();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	НачатьЗагрузкуКурсовВалют();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеВалюты(Команда)
	УстановитьВыбор(Истина);
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыбор(Команда)
	УстановитьВыбор(Ложь);
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ЗагружатьПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаКурса.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СписокВалют.ДатаКурса");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый СтандартнаяДатаНачала(Дата('19800101000000'));

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбор(Выбор)
	Для Каждого Валюта Из Объект.СписокВалют Цикл
		Валюта.Загружать = Выбор;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВалюты()
	
	// Заполнение табличной части списком валют, курс которых не зависит от курса других валют.
	СписокВалют = Объект.СписокВалют;
	СписокВалют.Очистить();
	
	ЗагружаемыеВалюты = РаботаСКурсамиВалют.ЗагружаемыеВалюты();
	
	Для Каждого ЭлементВалюта Из ЗагружаемыеВалюты Цикл
		ДобавитьВалютуВСписок(ЭлементВалюта);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВалютуВСписок(Валюта)
	
	// Добавление записи в список валют.
	НоваяСтрока = Объект.СписокВалют.Добавить();
	
	// Заполнение информации о курсе на основе ссылки валюты.
	ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(НоваяСтрока, Валюта);
	
	НоваяСтрока.Загружать = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСведенияВСпискеВалют()
	
	// Обновление записей о курсах валют в списке.
	
	Для Каждого СтрокаДанных Из Объект.СписокВалют Цикл
		СсылкаНаВалюту = СтрокаДанных.Валюта;
		ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(СтрокаДанных, СсылкаНаВалюту);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеСтрокиТаблицыНаОсновеВалюты(СтрокаТаблицы, Валюта);
	
	СведенияОВалюте = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Валюта, "НаименованиеПолное,Код,Наименование");
	
	СтрокаТаблицы.Валюта = Валюта;
	СтрокаТаблицы.КодВалюты = СведенияОВалюте.Код;
	СтрокаТаблицы.СимвольныйКод = СведенияОВалюте.Наименование;
	СтрокаТаблицы.Представление = СведенияОВалюте.НаименованиеПолное;
	
	ДанныеКурса = РаботаСКурсамиВалют.ЗаполнитьДанныеКурсаДляВалюты(Валюта);
	
	Если ТипЗнч(ДанныеКурса) = Тип ("Структура") Тогда
		СтрокаТаблицы.ДатаКурса = ДанныеКурса.ДатаКурса;
		СтрокаТаблицы.Курс      = ДанныеКурса.Курс;
		СтрокаТаблицы.Кратность = ДанныеКурса.Кратность;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСписокЗагружаемыхВалют()
	Если Объект.СписокВалют.Количество() = 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьСписокЗагружаемыхВалютЗавершение", ЭтотОбъект);
		ТекстПредупреждения = НСтр("ru = 'В справочнике валют отсутствуют валюты, курсы которых можно загружать из сети Интернет.'");
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСписокЗагружаемыхВалютЗавершение(ДополнительныеПараметры) Экспорт
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	ЕстьВыбранныеВалюты = Объект.СписокВалют.НайтиСтроки(Новый Структура("Загружать", Истина)).Количество() > 0;
	Элементы.ФормаЗагрузитьКурсыВалют.Доступность = ЕстьВыбранныеВалюты;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьЗагрузкуКурсаВыбраннойВалютыИзИнтернета(Команда)
	ТекущиеДанные = Элементы.СписокВалют.ТекущиеДанные;
	СнятьПризнакЗагрузкиИзИнтернета(ТекущиеДанные.Валюта);
	Объект.СписокВалют.Удалить(ТекущиеДанные);
КонецПроцедуры

&НаСервере
Процедура СнятьПризнакЗагрузкиИзИнтернета(ВалютаСсылка)
	ВалютаОбъект = ВалютаСсылка.ПолучитьОбъект();
	ВалютаОбъект.СпособУстановкиКурса = Перечисления.СпособыУстановкиКурсаВалюты.РучнойВвод;
	ВалютаОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьЗагрузку()
	Элементы.СписокВалют.ТекущиеДанные.Загружать = Не Элементы.СписокВалют.ТекущиеДанные.Загружать;
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Функция ВыполнитьЗагрузкуКурсов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют;
	
	НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"),
		РегламентноеЗадание.Синоним);
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("НачалоПериода", Объект.НачалоПериодаЗагрузки);
	ПараметрыЗагрузки.Вставить("КонецПериода", Объект.ОкончаниеПериодаЗагрузки);
	ПараметрыЗагрузки.Вставить("СписокВалют", ОбщегоНазначения.ТаблицаЗначенийВМассив(Объект.СписокВалют.Выгрузить(
		Объект.СписокВалют.НайтиСтроки(Новый Структура("Загружать", Истина)), "КодВалюты,Валюта")));
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновогоЗадания;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(РегламентноеЗадание.ИмяМетода, ПараметрыЗагрузки, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииЗагрузкиКурсов(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСписокВалют;
	Элементы.КоманднаяПанель.Доступность = Истина;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки + Символы.ПС + НСтр("ru = 'Подробности см. в журнале регистрации.'");
	КонецЕсли;
	
	ОбработатьРезультатЗагрузки(ПолучитьИзВременногоХранилища(Результат.АдресРезультата));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗагрузки(РезультатЗагрузки)
	
	ЕстьУспешноЗагруженныеКурсы = Ложь;
	БезОшибок = Истина;
	
	КоличествоОшибок = 0;
	
	СписокОшибок = Новый ТекстовыйДокумент;
	Для Каждого СостояниеЗагрузки Из РезультатЗагрузки Цикл
		Если СостояниеЗагрузки.СтатусОперации Тогда
			ЕстьУспешноЗагруженныеКурсы = Истина;
		Иначе
			БезОшибок = Ложь;
			КоличествоОшибок = КоличествоОшибок + 1;
			СписокОшибок.ДобавитьСтроку(СокрЛП(СостояниеЗагрузки.Сообщение) + Символы.ПС);
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьУспешноЗагруженныеКурсы Тогда
		ОбновитьСведенияВСпискеВалют();
		ПараметрыЗаписи = Неопределено;
		МассивОбновляемыхВалют = Новый Массив;
		Для Каждого СтрокаТаблицы Из Объект.СписокВалют Цикл
			МассивОбновляемыхВалют.Добавить(СтрокаТаблицы.Валюта);
		КонецЦикла;
		Оповестить("Запись_ЗагрузкаКурсовВалют", ПараметрыЗаписи, МассивОбновляемыхВалют);
		РаботаСКурсамиВалютКлиент.ОповеститьКурсыУспешноОбновлены();
	КонецЕсли;
	
	Если БезОшибок Тогда
		Закрыть();
	Иначе
		ПредставлениеОшибки = СокрЛП(СписокОшибок.ПолучитьТекст());
		Если КоличествоОшибок > 1 Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("Подробнее", НСтр("ru = 'Подробнее...'"));
			Кнопки.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось загрузить курсы валют (%1).'"), КоличествоОшибок);
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьРезультатЗагрузкиПриОтветеНаВопрос", ЭтотОбъект, ПредставлениеОшибки);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Иначе
			ПоказатьПредупреждение(, ПредставлениеОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультатЗагрузкиПриОтветеНаВопрос(РезультатВопроса, ПредставлениеОшибки) Экспорт
	Если РезультатВопроса <> "Подробнее" Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ЗагрузкаКурсовВалют.Форма.СообщенияОбОшибках", Новый Структура("Текст", ПредставлениеОшибки));	
КонецПроцедуры

&НаКлиенте
Процедура НачатьЗагрузкуКурсовВалют()
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для загрузки курсов валют из Интернета
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьЗагрузкуКурсовВалют();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриПодключенииИнтернетПоддержки(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект);
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт
	Если Не (ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)) Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьЗагрузкуКурсовВалют();
КонецПроцедуры

&НаСервере
Функция ТребуетсяНастройкаАвторизацияИнтернетПоддержки()
	УстановитьПривилегированныйРежим(Истина);
	ИспользоватьАльтернативныйСервер = Константы.ИспользоватьАльтернативныйСерверДляЗагрузкиКурсовВалют.Получить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ИспользоватьАльтернативныйСервер Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
			МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
			Возврат Не МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
		КонецЕсли;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПродолжитьЗагрузкуКурсовВалют()
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.НачалоПериодаЗагрузки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не задана дата начала периода загрузки.'"),
			,
			"Объект.НачалоПериодаЗагрузки");
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ОкончаниеПериодаЗагрузки) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Не задана дата окончания периода загрузки.'"),
			,
			"Объект.ОкончаниеПериодаЗагрузки");
		Возврат;
	КонецЕсли;
	
	ОперацияЗагрузкиКурсов = ВыполнитьЗагрузкуКурсов();
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыполняетсяЗагрузкаКурсов;
	Элементы.КоманднаяПанель.Доступность = Ложь;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриЗавершенииЗагрузкиКурсов", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ОперацияЗагрузкиКурсов, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти
