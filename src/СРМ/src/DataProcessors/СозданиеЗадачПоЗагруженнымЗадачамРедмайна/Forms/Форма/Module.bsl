&НаКлиенте
Процедура СоздатьЗадачи(Команда)
	СоздатьЗадачиНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоздатьЗадачиНаСервере()
	Если ДобавитьКНомерамТекущихЗадачCRMНачальныйНомер Тогда
		ПеренумероватьСуществующиеЗадачи();
	КонецЕсли;

	СоздатьЗадачиПоЗадачамРедмайна();
КонецПроцедуры

&НаСервере
Процедура ПеренумероватьСуществующиеЗадачи()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Задача.Ссылка
	|ИЗ
	|	Документ.Задача КАК Задача
	|ГДЕ
	|	Задача.Номер < &Номер";
	Запрос.УстановитьПараметр("Номер", НачальныйНомерЗадачиВСистеме);
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбъектЗадачи=Выборка.Ссылка.ПолучитьОбъект();
		ОбъектЗадачи.Номер=НачальныйНомерЗадачиВСистеме + ОбъектЗадачи.Номер;

		ОбъектЗадачи.ОбменДанными.Загрузка=Истина;
		ОбъектЗадачи.Записать();

	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьВидыАктивности()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineВидыАктивности.Ссылка,
	|	RA_RedmineВидыАктивности.Наименование
	|ИЗ
	|	Справочник.RA_RedmineВидыАктивности КАК RA_RedmineВидыАктивности
	|ГДЕ
	|	RA_RedmineВидыАктивности.ВидДеятельности = &ВидДеятельности";
	Запрос.УстановитьПараметр("ВидДеятельности", Справочники.ВидыДеятельности.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();

		НовыйВидДеятельности=Справочники.ВидыДеятельности.СоздатьЭлемент();
		НовыйВидДеятельности.Наименование=Выборка.Наименование;
		Попытка
			НовыйВидДеятельности.Записать();
		Исключение
			Сообщить("Ошибка создания вида деятельности " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		РедмайнВид=Выборка.Ссылка.ПолучитьОбъект();
		РедмайнВид.ВидДеятельности=НовыйВидДеятельности.Ссылка;
		РедмайнВид.ОбменДанными.Загрузка=Истина;
		РедмайнВид.Записать();
		Попытка
			РедмайнВид.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Ошибка создания вида деятельности " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;

	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьПользователей()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineПользователи.Ссылка,
	|	RA_RedmineПользователи.Наименование
	|ИЗ
	|	Справочник.RA_RedmineПользователи КАК RA_RedmineПользователи
	|ГДЕ
	|	RA_RedmineПользователи.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Справочники.Пользователи.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();

		НовыйЭлемент=Справочники.Пользователи.СоздатьЭлемент();
		НовыйЭлемент.Наименование=Выборка.Наименование;
		НовыйЭлемент.Недействителен=Истина;
		Попытка
			НовыйЭлемент.Записать();
		Исключение
			Сообщить("Ошибка создания пользователя " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		РедмайнЭлемент=Выборка.Ссылка.ПолучитьОбъект();
		РедмайнЭлемент.Пользователь=НовыйЭлемент.Ссылка;
		РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
		Попытка
			РедмайнЭлемент.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Ошибка создания пользователя " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СинхронизироватьПриоритеты()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineПриоритеты.Ссылка,
	|	RA_RedmineПриоритеты.Наименование
	|ИЗ
	|	Справочник.RA_RedmineПриоритеты КАК RA_RedmineПриоритеты
	|ГДЕ
	|	RA_RedmineПриоритеты.Срочность = &Срочность";
	Запрос.УстановитьПараметр("Срочность", Справочники.СрочностиЗадач.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();

		НовыйЭлемент=Справочники.СрочностиЗадач.СоздатьЭлемент();
		НовыйЭлемент.Наименование=Выборка.Наименование;
		Попытка
			НовыйЭлемент.Записать();
		Исключение
			Сообщить("Ошибка создания приоритета " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		РедмайнЭлемент=Выборка.Ссылка.ПолучитьОбъект();
		РедмайнЭлемент.Срочность=НовыйЭлемент.Ссылка;
		РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
		Попытка
			РедмайнЭлемент.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Ошибка создания приоритета " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СинхронизироватьСтатусы()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineСтатусы.Ссылка,
	|	RA_RedmineСтатусы.Наименование,
	|	RA_RedmineСтатусы.Закрыто,
	|	RA_RedmineСтатусы.Платный,
	|	RA_RedmineСтатусы.ВидСтатуса
	|ИЗ
	|	Справочник.RA_RedmineСтатусы КАК RA_RedmineСтатусы
	|ГДЕ
	|	RA_RedmineСтатусы.Статус = &Статус";
	Запрос.УстановитьПараметр("Статус", Справочники.СтатусыЗадач.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();

		НовыйЭлемент=Справочники.СтатусыЗадач.СоздатьЭлемент();
		НовыйЭлемент.Наименование=Выборка.Наименование;
		Если Выборка.ВидСтатуса = Перечисления.RA_RedmineВидыСтатусовЗадач.Новая Тогда
			НовыйЭлемент.Вид=Перечисления.ВидыСтатусовЗадач.Новая;
		ИначеЕсли Выборка.ВидСтатуса = Перечисления.RA_RedmineВидыСтатусовЗадач.ВРаботе Тогда
			НовыйЭлемент.Вид=Перечисления.ВидыСтатусовЗадач.ВРаботе;
		ИначеЕсли Выборка.ВидСтатуса = Перечисления.RA_RedmineВидыСтатусовЗадач.Отменена Тогда
			НовыйЭлемент.Вид=Перечисления.ВидыСтатусовЗадач.Отклонена;
		ИначеЕсли Выборка.ВидСтатуса = Перечисления.RA_RedmineВидыСтатусовЗадач.Решена И Выборка.Закрыто Тогда
			НовыйЭлемент.Вид=Перечисления.ВидыСтатусовЗадач.Закрыта;
		Иначе
			НовыйЭлемент.Вид=Перечисления.ВидыСтатусовЗадач.Выполнена;
		КонецЕсли;
		Попытка
			НовыйЭлемент.Записать();
		Исключение
			Сообщить("Ошибка создания статуса " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		РедмайнЭлемент=Выборка.Ссылка.ПолучитьОбъект();
		РедмайнЭлемент.Статус=НовыйЭлемент.Ссылка;
		РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
		Попытка
			РедмайнЭлемент.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Ошибка создания статуса " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция СоздатьПроект(ПроектРедмайна)
	Если не ЗначениеЗаполнено(ПроектРедмайна) Тогда
		Возврат Справочники.Проекты.ПустаяСсылка();
	ИначеЕсли ЗначениеЗаполнено(ПроектРедмайна.Проект) Тогда
		Возврат ПроектРедмайна.Проект;
	КонецЕсли;

	НачатьТранзакцию();

	НовыйЭлемент=Справочники.Проекты.СоздатьЭлемент();
	НовыйЭлемент.Наименование=ПроектРедмайна.Наименование;
	НовыйЭлемент.Партнер=ПроектРедмайна.Партнер;
	НовыйЭлемент.Архивный=ПроектРедмайна.Закрыт;
	НовыйЭлемент.Описание=ПроектРедмайна.Описание;
	НовыйЭлемент.Родитель=СоздатьПроект(ПроектРедмайна.Родитель);
	Попытка
		НовыйЭлемент.Записать();

		РедмайнЭлемент=ПроектРедмайна.ПолучитьОбъект();
		РедмайнЭлемент.Проект=НовыйЭлемент.Ссылка;
		РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
		РедмайнЭлемент.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		Сообщить("Ошибка создания проекта " + ПроектРедмайна.Наименование + ":" + ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;
	Возврат НовыйЭлемент.Ссылка;
КонецФункции

&НаСервере
Процедура СинхронизироватьПроекты()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineПроекты.Ссылка,
	|	RA_RedmineПроекты.Наименование,
	|	RA_RedmineПроекты.Платный,
	|	RA_RedmineПроекты.Закрыт,
	|	RA_RedmineПроекты.Описание,
	|	RA_RedmineПроекты.Партнер
	|ИЗ
	|	Справочник.RA_RedmineПроекты КАК RA_RedmineПроекты
	|ГДЕ
	|	RA_RedmineПроекты.Проект = &Проект";
	Запрос.УстановитьПараметр("Проект", Справочники.Проекты.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоздатьПроект(Выборка.Ссылка);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура СинхронизироватьВерсии()
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineВерсии.Ссылка,
	|	RA_RedmineВерсии.Наименование,
	|	RA_RedmineВерсии.Проект
	|ИЗ
	|	Справочник.RA_RedmineВерсии КАК RA_RedmineВерсии
	|ГДЕ
	|	RA_RedmineВерсии.Спринт = &Спринт";
	Запрос.УстановитьПараметр("Спринт", Документы.Спринт.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();

		НовыйЭлемент=Документы.Спринт.СоздатьДокумент();
		НовыйЭлемент.Дата=ТекущаяДата();
		НовыйЭлемент.Наименование=Выборка.Наименование;
		НовыйЭлемент.Проект=Выборка.Проект.Проект;
		НовыйЭлемент.Завершен=Истина;
		Попытка
			НовыйЭлемент.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить("Ошибка создания статуса " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		РедмайнЭлемент=Выборка.Ссылка.ПолучитьОбъект();
		РедмайнЭлемент.Спринт=НовыйЭлемент.Ссылка;
		РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
		Попытка
			РедмайнЭлемент.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Ошибка создания статуса " + Выборка.Наименование + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ВидСвязиПоВидуРедмайна(ВидСвязиРедмайна)
	Если ВидСвязиРедмайна = "relates" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Связана;
	ИначеЕсли ВидСвязиРедмайна = "duplicates" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Дублирует;
	ИначеЕсли ВидСвязиРедмайна = "duplicated" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Дублируется;
	ИначеЕсли ВидСвязиРедмайна = "blocks" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Блокирует;
	ИначеЕсли ВидСвязиРедмайна = "blocked" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Блокируется;
	ИначеЕсли ВидСвязиРедмайна = "precedes" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Следующая;
	ИначеЕсли ВидСвязиРедмайна = "follows" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.Предыдущая;
	ИначеЕсли ВидСвязиРедмайна = "copied_to" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.СкопированаВ;
	ИначеЕсли ВидСвязиРедмайна = "copied_from" Тогда
		Возврат Перечисления.ТипыСвязиЗадачи.СкопированаС;

	Иначе
		Возврат Перечисления.ТипыСвязиЗадачи.Связана;
	КонецЕсли;
КонецФункции

&НаСервере
Функция СоздатьЗадачу(ЗадачаРедмайна)
	Если не ЗначениеЗаполнено(ЗадачаРедмайна) Тогда
		Возврат Документы.Задача.ПустаяСсылка();
	ИначеЕсли ЗначениеЗаполнено(ЗадачаРедмайна.Задача) Тогда
		Возврат ЗадачаРедмайна.Задача;
	КонецЕсли;

	ДанныеЗадачиИзРедмайна=RA_RedmineПротоколПодключения.ПолучитьДанныеПоЗадаче(НастройкаПодключения,
		ЗадачаРедмайна.Код, "attachments,relations,watchers");

	НачатьТранзакцию();

	НовыйЭлемент=Документы.Задача.СоздатьДокумент();
	НовыйЭлемент.Дата=ЗадачаРедмайна.ДатаСоздания;
	НовыйЭлемент.Номер=СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ЗадачаРедмайна.Код);
	НовыйЭлемент.Автор=ЗадачаРедмайна.Автор.Пользователь;
	НовыйЭлемент.ДатаВыполнения=ЗадачаРедмайна.ДатаЗакрытия;
	НовыйЭлемент.ДатаЗакрытия=ЗадачаРедмайна.ДатаЗакрытия;
	НовыйЭлемент.ДатаИзменения=ЗадачаРедмайна.ДатаОбновления;
	НовыйЭлемент.ДатаСоздания=ЗадачаРедмайна.ДатаСоздания;
	НовыйЭлемент.Исполнитель=ЗадачаРедмайна.Исполнитель.Пользователь;
	НовыйЭлемент.КонтактОбращения=ЗадачаРедмайна.КонтактОбращения;
	НовыйЭлемент.ОценкаТрудозатрат=ЗадачаРедмайна.ОценкаТрудозатрат;
	НовыйЭлемент.ОценкаТрудозатратИсполнителя=ЗадачаРедмайна.StoryPoints;
	Если ДанныеЗадачиИзРедмайна.Свойство("parent") Тогда
		НовыйЭлемент.РодительскаяЗадача=СоздатьЗадачу(RA_RedmineСервер.НайтиСоздатьЗадачу(Формат(
			ДанныеЗадачиИзРедмайна.parent.id, "ЧГ=0;"), Ложь));
	КонецЕсли;
	НовыйЭлемент.Проект=ЗадачаРедмайна.Проект.Проект;
	НовыйЭлемент.Содержание=ЗадачаРедмайна.Описание;
	НовыйЭлемент.СодержаниеФормат=Перечисления.ФорматыТекстаКомментариев.Markdown;
	Если ДанныеЗадачиИзРедмайна.Свойство("fixed_version") Тогда
		НовыйЭлемент.Спринт=Справочники.RA_RedmineВерсии.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ДанныеЗадачиИзРедмайна.fixed_version)).Спринт;
	КонецЕсли;
//	НовыйЭлемент.СрокИсполнения=Перечисления.ФорматыТекстаКомментариев.Markdown;
	НовыйЭлемент.Срочность=ЗадачаРедмайна.Приоритет.Срочность;
	НовыйЭлемент.Статус=ЗадачаРедмайна.Статус.Статус;
	НовыйЭлемент.Тема=ЗадачаРедмайна.наименование;
	Попытка
		НовыйЭлемент.ДополнительныеСвойства.Вставить("БезОповещений", Истина);
		НовыйЭлемент.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Сообщить("Ошибка создания задачи " + ЗадачаРедмайна + ":" + ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;
	РедмайнЭлемент=ЗадачаРедмайна.ПолучитьОбъект();
	РедмайнЭлемент.Задача=НовыйЭлемент.Ссылка;
	РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
	Попытка
		РедмайнЭлемент.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		Сообщить("Ошибка создания статуса " + ЗадачаРедмайна + ":" + ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;
	
	//Наблюдатели
	Если ДанныеЗадачиИзРедмайна.Свойство("watchers") Тогда
		Для Каждого НаблюдательРедмайна Из ДанныеЗадачиИзРедмайна.watchers Цикл
			Наблюдатель=RA_RedmineСервер.НайтиСоздатьПользователя(НаблюдательРедмайна);

			УправлениеЗадачами.ДобавитьНаблюдателя(НовыйЭлемент.Ссылка, Наблюдатель);
		КонецЦикла;
	КонецЕсли;
	Если ДанныеЗадачиИзРедмайна.Свойство("relations") Тогда
		Для Каждого СвязьЗадачи Из ДанныеЗадачиИзРедмайна.relations Цикл
			УправлениеЗадачами.ДобавитьСвязьЗадач(НовыйЭлемент.Ссылка, RA_RedmineСервер.НайтиСоздатьЗадачу(Формат(
				СвязьЗадачи.issue_to_id, "ЧГ=0;"), Ложь), ВидСвязиПоВидуРедмайна(СвязьЗадачи.relation_type));
		КонецЦикла;
	КонецЕсли;
	Если ДанныеЗадачиИзРедмайна.Свойство("attachments") Тогда
		Для Каждого Вложение Из ДанныеЗадачиИзРедмайна.attachments Цикл
			АвторВложения=RA_RedmineСервер.НайтиСоздатьПользователя(Вложение.author);
			ДанныеВложения=RA_RedmineПротоколПодключения.ПолучитьДанныеВложения(НастройкаПодключения, Формат(
				Вложение.id, "ЧГ=0;"), Вложение.filename);
			
			Если ДанныеВложения=Неопределено Тогда
				Сообщить("Не удалось загрузить вложение по задаче "+НовыйЭлемент.Ссылка+" "+Вложение.id+" "+Вложение.filename);
				Продолжить;
			КонецЕсли;
			АдресФайлаВоВременномХранилище=ПоместитьВоВременноеХранилище(ДанныеВложения, УникальныйИдентификатор);
			МассивИмениФайла=СтрРазделить(Вложение.filename, ".");

			ПараметрыФайла =Новый Структура;
			ПараметрыФайла.Вставить("Автор", АвторВложения.Пользователь);
			ПараметрыФайла.Вставить("ВладелецФайлов", НовыйЭлемент.Ссылка);
			ПараметрыФайла.Вставить("Автор", АвторВложения.Пользователь);
			ПараметрыФайла.Вставить("Служебный", Ложь);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяУниверсальнаяДата());
			ПараметрыФайла.Вставить("ГруппаФайлов", Неопределено);
			Если МассивИмениФайла.Количество() = 1 Тогда
				ПараметрыФайла.Вставить("ИмяБезРасширения", Вложение.filename);
				ПараметрыФайла.Вставить("РасширениеБезТочки", "");
			Иначе
				ПараметрыФайла.Вставить("РасширениеБезТочки", МассивИмениФайла[МассивИмениФайла.Количество() - 1]);
				МассивИмениФайла.Удалить(МассивИмениФайла.Количество() - 1);
				ПараметрыФайла.Вставить("ИмяБезРасширения", СтрСоединить(МассивИмениФайла, "."));
			КонецЕсли;

			РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайлаВоВременномХранилище);
		КонецЦикла;
	КонецЕсли;

	Возврат НовыйЭлемент.Ссылка;
КонецФункции

&НаСервере
Процедура СинхронизироватьЗадачи()
	Если Не ЗагружатьЗадачи Тогда
		Возврат;
	КонецЕсли;
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineЗадачи.Ссылка
	|ИЗ
	|	Справочник.RA_RedmineЗадачи КАК RA_RedmineЗадачи
	|ГДЕ
	|	RA_RedmineЗадачи.Задача = &Задача";
	Запрос.УстановитьПараметр("Задача", Документы.Задача.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СоздатьЗадачу(Выборка.Ссылка);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СинхронизироватьИзмененияЗадач()
	Если Не ИсторияЗадач Тогда
		Возврат;
	КонецЕсли;
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineИзмененияЗадач.Ссылка,
	|	RA_RedmineИзмененияЗадач.ВидИзменения,
	|	RA_RedmineИзмененияЗадач.ДатаСоздания,
	|	RA_RedmineИзмененияЗадач.Пользователь,
	|	RA_RedmineИзмененияЗадач.Комментарий,
	|	RA_RedmineИзмененияЗадач.Состав.(
	|		Ссылка,
	|		НомерСтроки,
	|		Свойство,
	|		Имя,
	|		СтароеЗначение,
	|		НовоеЗначение),
	|	RA_RedmineИзмененияЗадач.Владелец
	|ИЗ
	|	Справочник.RA_RedmineИзмененияЗадач КАК RA_RedmineИзмененияЗадач
	|ГДЕ
	|	RA_RedmineИзмененияЗадач.КомментарийЗадачи = &КомментарийЗадачи";
	Запрос.УстановитьПараметр("КомментарийЗадачи", Справочники.КомментарииЗадач.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		Если Выборка.ВидИзменения = Перечисления.RA_RedmineВидыИзмененийЗадач.Комментарий Тогда
			НачатьТранзакцию();
			НовыйЭлемент=Справочники.КомментарииЗадач.СоздатьЭлемент();
			НовыйЭлемент.Задача=СоздатьЗадачу(Выборка.Владелец);
			НовыйЭлемент.Автор=Выборка.Пользователь.Пользователь;
			НовыйЭлемент.ДатаСоздания=Выборка.ДатаСоздания;
			НовыйЭлемент.Автор=Выборка.Пользователь.Пользователь;
			НовыйЭлемент.ТекстСообщения=Выборка.Комментарий;
			НовыйЭлемент.ТекстСообщенияФормат=Перечисления.ФорматыТекстаКомментариев.Markdown;
			Попытка
				НовыйЭлемент.ДополнительныеСвойства.Вставить("БезОповещений", Истина);
				НовыйЭлемент.Записать();
			Исключение
				Сообщить("Ошибка создания статуса " + Выборка.Наименование + ":" + ОписаниеОшибки());
				ОтменитьТранзакцию();
			КонецПопытки;
			РедмайнЭлемент=Выборка.Ссылка.ПолучитьОбъект();
			РедмайнЭлемент.КомментарийЗадачи=НовыйЭлемент.Ссылка;
			РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
			Попытка
				РедмайнЭлемент.Записать();
				ЗафиксироватьТранзакцию();
			Исключение
				Сообщить("Ошибка создания статуса " + Выборка.Наименование + ":" + ОписаниеОшибки());
				ОтменитьТранзакцию();
			КонецПопытки;

		КонецЕсли;
		ВыборкаСостав=Выборка.Состав.Выбрать();
		Пока ВыборкаСостав.Следующий() Цикл
			Если ВыборкаСостав.Свойство <> "attr" Тогда
				Продолжить;
			КонецЕсли;

			ЗаписьИсторииИзменений=РегистрыСведений.ИзмененияЗадач.СоздатьМенеджерЗаписи();
			ЗаписьИсторииИзменений.Задача=СоздатьЗадачу(Выборка.Владелец);
			ЗаписьИсторииИзменений.Дата=Выборка.ДатаСоздания;
			ЗаписьИсторииИзменений.Автор=Выборка.Пользователь.Пользователь;
			Если ВыборкаСостав.Имя = "project_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="Проект";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=Справочники.RA_RedmineПроекты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)).Проект;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=Справочники.RA_RedmineПроекты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)).Проект;
				КонецЕсли;
			ИначеЕсли ВыборкаСостав.Имя = "status_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="Статус";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=Справочники.RA_RedmineСтатусы.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)).Статус;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=Справочники.RA_RedmineСтатусы.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)).Статус;
				КонецЕсли;
			ИначеЕсли ВыборкаСостав.Имя = "assigned_to_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="Исполнитель";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=Справочники.RA_RedmineПользователи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)).Пользователь;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=Справочники.RA_RedmineПользователи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)).Пользователь;
				КонецЕсли;
			ИначеЕсли ВыборкаСостав.Имя = "estimated_hours" Тогда
				ЗаписьИсторииИзменений.Реквизит="ОценкаТрудозатрат";
				ЗаписьИсторииИзменений.ПредыдущееЗначение=ВыборкаСостав.СтароеЗначение;
				ЗаписьИсторииИзменений.НовоеЗначение=ВыборкаСостав.НовоеЗначение;
			ИначеЕсли ВыборкаСостав.Имя = "story_points" Тогда
				ЗаписьИсторииИзменений.Реквизит="ОценкаТрудозатратИсполнителя";
				ЗаписьИсторииИзменений.ПредыдущееЗначение=ВыборкаСостав.СтароеЗначение;
				ЗаписьИсторииИзменений.НовоеЗначение=ВыборкаСостав.НовоеЗначение;
			ИначеЕсли ВыборкаСостав.Имя = "subject" Тогда
				ЗаписьИсторииИзменений.Реквизит="Тема";
				ЗаписьИсторииИзменений.ПредыдущееЗначение=ВыборкаСостав.СтароеЗначение;
				ЗаписьИсторииИзменений.НовоеЗначение=ВыборкаСостав.НовоеЗначение;
			ИначеЕсли ВыборкаСостав.Имя = "fixed_version_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="Спринт";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=Справочники.RA_RedmineВерсии.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)).Спринт;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=Справочники.RA_RedmineВерсии.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)).Спринт;
				КонецЕсли;
			ИначеЕсли ВыборкаСостав.Имя = "parent_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="РодительскаяЗадача";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=СоздатьЗадачу(Справочники.RA_RedmineЗадачи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)));
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=СоздатьЗадачу(Справочники.RA_RedmineЗадачи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)));
				КонецЕсли;
			ИначеЕсли ВыборкаСостав.Имя = "description" Тогда
				ЗаписьИсторииИзменений.Реквизит="Содержание";
				ЗаписьИсторииИзменений.ПредыдущееЗначение=ВыборкаСостав.СтароеЗначение;
				ЗаписьИсторииИзменений.НовоеЗначение=ВыборкаСостав.НовоеЗначение;
			ИначеЕсли ВыборкаСостав.Имя = "priority_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="Срочность";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=Справочники.RA_RedmineПриоритеты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)).Срочность;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=Справочники.RA_RedmineПриоритеты.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)).Срочность;
				КонецЕсли;
			ИначеЕсли ВыборкаСостав.Имя = "author_id" Тогда
				ЗаписьИсторииИзменений.Реквизит="Автор";
				Если ЗначениеЗаполнено(ВыборкаСостав.СтароеЗначение) Тогда
					ЗаписьИсторииИзменений.ПредыдущееЗначение=Справочники.RA_RedmineПользователи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.СтароеЗначение)).Пользователь;
				КонецЕсли;
				Если ЗначениеЗаполнено(ВыборкаСостав.НовоеЗначение) Тогда
					ЗаписьИсторииИзменений.НовоеЗначение=Справочники.RA_RedmineПользователи.НайтиПоКоду(RA_ОбщегоНазначенияСервер.ФорматЧислоБезРазделителей(ВыборкаСостав.НовоеЗначение)).Пользователь;
				КонецЕсли;
			Иначе
				Продолжить;
			КонецЕсли;
			ЗаписьИсторииИзменений.Записать(Истина);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СинхронизироватьТрудозатраты()
	Если Не Трудозатраты Тогда
		Возврат;
	КонецЕсли;

	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	RA_RedmineТрудозатраты.Задача,
	|	RA_RedmineТрудозатраты.ДатаСоздания,
	|	RA_RedmineТрудозатраты.ДатаОтбивки,
	|	RA_RedmineТрудозатраты.КоличествоЧасов,
	|	RA_RedmineТрудозатраты.Пользователь,
	|	RA_RedmineТрудозатраты.ВидАктивности,
	|	RA_RedmineТрудозатраты.Проект,
	|	RA_RedmineТрудозатраты.ДатаОбновления,
	|	RA_RedmineТрудозатраты.Описание,
	|	RA_RedmineТрудозатраты.Ссылка
	|ИЗ
	|	Справочник.RA_RedmineТрудозатраты КАК RA_RedmineТрудозатраты
	|ГДЕ
	|	RA_RedmineТрудозатраты.Трудозатраты = &Трудозатраты";
	Запрос.УстановитьПараметр("Трудозатраты", Документы.Трудозатраты.ПустаяСсылка());

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();

		НовыйЭлемент=Документы.Трудозатраты.СоздатьДокумент();
		НовыйЭлемент.Дата=Выборка.ДатаОтбивки;
		НовыйЭлемент.Предмет=Выборка.Задача.Задача;
		Если Не ЗначениеЗаполнено(НовыйЭлемент.Предмет) Тогда
			НовыйЭлемент.Предмет=Выборка.Проект.Проект;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НовыйЭлемент.Предмет) Тогда
			Продолжить;
		КонецЕсли;
		НовыйЭлемент.Часов=Выборка.КоличествоЧасов;
		НовыйЭлемент.ВидДеятельности=Выборка.ВидАктивности.ВидДеятельности;
		НовыйЭлемент.Автор=Выборка.Пользователь.Пользователь;
		НовыйЭлемент.ДатаСоздания=Выборка.ДатаСоздания;
		НовыйЭлемент.ДатаИзменения=Выборка.ДатаОбновления;
		НовыйЭлемент.Автор=Выборка.Пользователь.Пользователь;
		НовыйЭлемент.Редактор=Выборка.Пользователь.Пользователь;
		НовыйЭлемент.Комментарий=Выборка.Описание;
		Попытка
			НовыйЭлемент.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить("Ошибка создания статуса " + Выборка.Ссылка + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;
		РедмайнЭлемент=Выборка.Ссылка.ПолучитьОбъект();
		РедмайнЭлемент.Трудозатраты=НовыйЭлемент.Ссылка;
		РедмайнЭлемент.ОбменДанными.Загрузка=Истина;
		Попытка
			РедмайнЭлемент.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Ошибка создания статуса " + Выборка.Ссылка + ":" + ОписаниеОшибки());
			ОтменитьТранзакцию();
		КонецПопытки;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СоздатьЗадачиПоЗадачамРедмайна()
	//1. Виды активности
	СинхронизироватьВидыАктивности();
	//2. Пользователи
	СинхронизироватьПользователей();
	
	//3. Приоритеты
	СинхронизироватьПриоритеты();
	//4. Статусы
	СинхронизироватьСтатусы();
	//5. Проекты
	СинхронизироватьПроекты();
	//5.1. Версии
	СинхронизироватьВерсии();
	
	//6. Задачи
	СинхронизироватьЗадачи();
	//7. Изменения задач
	СинхронизироватьИзмененияЗадач();
	//8. Трудозатраты
	СинхронизироватьТрудозатраты();
КонецПроцедуры