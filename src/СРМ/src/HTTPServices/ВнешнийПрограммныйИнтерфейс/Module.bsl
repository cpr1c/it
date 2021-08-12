

#Область Задачи

Функция СписокЗадачGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("Привер");
	Возврат Ответ;
КонецФункции

Функция ДанныеЗадачиGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	Идентификатор = Запрос.ПараметрыURL["id"];
	
	Попытка
		НайденнаяСсылка = Документы.Задача.ПолучитьСсылку(Новый УникальныйИдентификатор(Идентификатор));
	Исключение
		
		НайденнаяСсылка = УправлениеЗадачами.НайтиЗадачуПоНомеру(СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Идентификатор));
		
		Если Не ЗначениеЗаполнено(НайденнаяСсылка) Тогда 
			Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(Истина, "Задача не найдена", ПараметрыЛога);
		КонецЕсли;
	КонецПопытки;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НайденнаяСсылка,"Ссылка") = Неопределено Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(Истина, "Задача не найдена", ПараметрыЛога);
	КонецЕсли;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(Ложь, ВнешнийПрограммныйИнтерфейс.ОписаниеЗадачи(НайденнаяСсылка), ПараметрыЛога);
КонецФункции

#КонецОбласти

#Область Пользователи

Функция ПользователиGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(ПараметрыЛога);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Ссылка,
	|	Пользователи.Наименование КАК Наименование,
	|	Пользователи.Недействителен КАК Недействителен,
	|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Недействителен";
	
	ЕстьОшибки = Ложь;
	МассивПользователей = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ) Тогда
			Продолжить;
		КонецЕсли;
		МассивПользователей.Добавить(ВнешнийПрограммныйИнтерфейс.ОписаниеПользователя(Выборка));
	КонецЦикла;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(ЕстьОшибки, МассивПользователей, ПараметрыЛога);
КонецФункции

#КонецОбласти

Функция СписокПроектовGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Проекты.Ссылка КАК Ссылка,
	|	Проекты.Наименование КАК Наименование,
	|	Проекты.Родитель КАК Родитель,
	|	Проекты.Партнер КАК Партнер,
	|	Проекты.Описание КАК Описание,
	|	Проекты.Архивный КАК Архивный,
	|	Проекты.Вид КАК Вид
	|ИЗ
	|	Справочник.Проекты КАК Проекты";
	
	ЕстьОшибки = Ложь;
	МассивДанных = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивДанных.Добавить(ВнешнийПрограммныйИнтерфейс.ОписаниеПроекта(Выборка));
	КонецЦикла;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(ЕстьОшибки, МассивДанных, ПараметрыЛога);
КонецФункции

Функция ДанныеПроектаGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	ИдентификаторПроекта = Запрос.ПараметрыURL["id"];	
	
	Попытка
		НайденныйПроект = Справочники.Проекты.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторПроекта));
	Исключение
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(Истина, "Проект с текущим идентификатором не найден", ПараметрыЛога);
	КонецПопытки;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НайденныйПроект,"Ссылка") = Неопределено Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(Истина, "Проект с текущим идентификатором не найден", ПараметрыЛога);
	КонецЕсли;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(Ложь, ВнешнийПрограммныйИнтерфейс.ОписаниеПроекта(НайденныйПроект), ПараметрыЛога);
КонецФункции

Функция СписокСтатусовGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтатусыЗадач.Ссылка КАК Ссылка,
	|	СтатусыЗадач.Наименование КАК Наименование,
	|	СтатусыЗадач.Вид КАК Вид
	|ИЗ
	|	Справочник.СтатусыЗадач КАК СтатусыЗадач";
	
	ЕстьОшибки = Ложь;
	МассивДанных = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивДанных.Добавить(ВнешнийПрограммныйИнтерфейс.ОписаниеСтатуса(Выборка));
	КонецЦикла;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(ЕстьОшибки, МассивДанных, ПараметрыЛога);
КонецФункции

Функция СписокКатегорийЗадачGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КатегорииЗакрытияЗадач.Ссылка КАК Ссылка,
	|	КатегорииЗакрытияЗадач.Наименование КАК Наименование,
	|	КатегорииЗакрытияЗадач.Родитель КАК Родитель
	|ИЗ
	|	Справочник.КатегорииЗакрытияЗадач КАК КатегорииЗакрытияЗадач";
	
	ЕстьОшибки = Ложь;
	МассивДанных = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивДанных.Добавить(ВнешнийПрограммныйИнтерфейс.ОписаниеКатегорииЗадачи(Выборка));
	КонецЦикла;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(ЕстьОшибки, МассивДанных, ПараметрыЛога);
КонецФункции

Функция ВидыОплатGET(Запрос)
	ПараметрыЛога = ВнешнийПрограммныйИнтерфейс.НовыеПараметрыЛогаHTTPЗапроса(Запрос);
	Если Не ВнешнийПрограммныйИнтерфейс.ВнешнийПрограммныйИнтерфейсВключен() Тогда
		Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервисаПриОтключенномПрограммномИнтерфейсе(ПараметрыЛога);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыОплатыЗадач.Ссылка КАК Ссылка,
	|	ВидыОплатыЗадач.Наименование КАК Наименование
	|ИЗ
	|	Справочник.ВидыОплатыЗадач КАК ВидыОплатыЗадач";
	
	ЕстьОшибки = Ложь;
	МассивДанных = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивДанных.Добавить(ВнешнийПрограммныйИнтерфейс.ОписаниеВидОплаты(Выборка));
	КонецЦикла;
	
	Возврат ВнешнийПрограммныйИнтерфейс.ОтветСервиса(ЕстьОшибки, МассивДанных, ПараметрыЛога);
КонецФункции
