////////////////////////////////////////////////////////////////////////////////
//ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


////////////////////////////////////////////////////////////////////////////////
//ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


Процедура ОбновитьРеквизитДоговор()
	
	Если не ЗначениеЗаполнено(Договор) Тогда
		НовыйЭл=Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
	Иначе
		НовыйЭл=Договор.ПолучитьОбъект();
	КонецЕсли;
	
	НовыйЭл.Владелец=Контрагент;
	НовыйЭл.Организация=Организация;
	НовыйЭл.Партнер=Контрагент.Партнер;
	НовыйЭл.Наименование=СокрЛП(НомерДоговора);
	НовыйЭл.ТипДоговора=ТипДоговора;
	НовыйЭл.ВалютаРасчетов=Валюта;
	НовыйЭл.Записать();
	
	Договор=НовыйЭл.Ссылка;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая реквизиты шапки документа и результаты запроса по шапке
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, ТаблицаПоСуммамДолга, Отказ, Заголовок)

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - структура, содержащая реквизиты шапки документа и результаты запроса по шапке
//  ТаблицаПоСуммамДолга          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения,   Отказ)
	
	Движение=Движения.ДанныеДоговора.Добавить();
	Движение.Договор=Договор;
	Движение.Период=Дата;
	Движение.Вид=Вид;
	Движение.ДатаКонца=ДатаКонца;
	Движение.ДатаНачала=ДатаНачала;
	Движение.Контрагент=Контрагент;
	Движение.Тариф=Тариф;
	Движение.НомерДоговора=НомерДоговора;
	Движение.Организация=Организация;
	Движение.Периодичность=Периодичность;
	Движение.Статус=Статус;
	Движение.Адрес			=Адрес;
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)   
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	ОбновитьРеквизитДоговор();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДругоеЗаключениеДоговора = Биллинг.ПроверитьУникальностьНомераДоговора(НомерДоговора, Договор);
	
	Если ЗначениеЗаполнено(ДругоеЗаключениеДоговора) Тогда
		Сообщить("Договор №" + НомерДоговора + " уже заключен: " + ДругоеЗаключениеДоговора);
		Отказ = Истина;
	КонецЕсли;
	
	// Движения по документу
	Если Не Отказ Тогда
		
		Движения.ДанныеДоговора.Очистить();
		Движения.ДанныеДоговора.Записывать=Истина;
		
		ДвиженияПоРегистрам(РежимПроведения,   Отказ);

	КонецЕсли; 

КонецПроцедуры	// ОбработкаПроведения()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		Биллинг.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
		Статус=Перечисления.СтатусыДоговоров.Действующий;
		Валюта=Константы.ВалютаРегламентированогоУчета.Получить();
		Периодичность = Перечисления.Периодичность.Месяц;

	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
КонецПроцедуры

