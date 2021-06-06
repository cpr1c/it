////////////////////////////////////////////////////////////////////////////////
// Работа с таймерами учета трудозатрат
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

#Область ВзаимодействиеСПолемHTML

Функция ТекстПоляHTMLТаймеров() Экспорт
	Возврат ПолучитьОбщийМакет("ПолеТаймеров").ПолучитьТекст();
КонецФункции

#КонецОбласти

#Область УправлениеТаймером
Функция СоздатьИСтартоватьТаймер(Предмет) Экспорт
	Идентификатор=ИдентификаторТаймераПоПредмету(Предмет);
	Если Идентификатор = Неопределено Тогда
		Идентификатор=СоздатьТаймер(Предмет);
	КонецЕсли;

	СтартоватьТаймер(Идентификатор);

	Возврат Идентификатор;
КонецФункции

Процедура СтартоватьТаймер(Идентификатор) Экспорт
	ДанныеТаймера=ДанныеТаймера(Идентификатор);

	Если ТаймерАктивен(ДанныеТаймера) Тогда
		Возврат;
	КонецЕсли;
	ОстановитьДругиеЗапущенныеТаймеры(Идентификатор);

	ДанныеТаймера.ДатаНачала = ТекущаяУниверсальнаяДата();
	ДанныеТаймера.ДатаОкончания = '00010101000000';
	ДанныеТаймера.СчетчикЗапусков = ДанныеТаймера.СчетчикЗапусков + 1;
	ОтразитьИзменениеТаймераУчетаВремени(Идентификатор, ДанныеТаймера);

КонецПроцедуры

Функция СоздатьТаймер(Предмет) Экспорт
	НовыйТаймер=РегистрыСведений.Таймеры.СоздатьМенеджерЗаписи();
	НовыйТаймер.Идентификатор=Строка(Новый УникальныйИдентификатор);
	НовыйТаймер.Пользователь=Пользователи.ТекущийПользователь();
	НовыйТаймер.Предмет=Предмет;
	НовыйТаймер.ВидДеятельности=Справочники.ВидыДеятельности.ПолучитьВидДеятельностиПоУмолчанию();
	НовыйТаймер.ДатаСозданияВМилисекундах=ТекущаяУниверсальнаяДатаВМиллисекундах();
	НовыйТаймер.Записать(Истина);

	Возврат НовыйТаймер.Идентификатор;

КонецФункции

Процедура ОстановитьТаймер(Идентификатор) Экспорт
	ДанныеТаймера=ДанныеТаймера(Идентификатор);
	Если Не ТаймерАктивен(ДанныеТаймера) Тогда
		Возврат;
	КонецЕсли;
	ДанныеТаймера.ДатаОкончания = ТекущаяУниверсальнаяДата();
	ДанныеТаймера.Часов = ДанныеТаймера.Часов + УчетВремениКлиентСервер.РазностьДатВЧасах(ДанныеТаймера.ДатаНачала,
		ДанныеТаймера.ДатаОкончания);
	ОтразитьИзменениеТаймераУчетаВремени(Идентификатор, ДанныеТаймера);

КонецПроцедуры

Процедура УдалитьТаймер(Идентификатор) Экспорт
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат;
	КонецЕсли;
	Набор = РегистрыСведений.Таймеры.СоздатьНаборЗаписей();
	Набор.Отбор.Идентификатор.Установить(Идентификатор);
	Набор.Записать(Истина);
КонецПроцедуры

#КонецОбласти

#Область ИнформацияОТаймерах

Функция ТаймерОстановлен(ДанныеТаймера) Экспорт
	Возврат Не ЗначениеЗаполнено(ДанныеТаймера.ДатаНачала) Или ЗначениеЗаполнено(
		ДанныеТаймера.ДатаОкончания);
КонецФункции

Функция ТаймерАктивен(ДанныеТаймера) Экспорт
	Возврат ЗначениеЗаполнено(ДанныеТаймера.ДатаНачала) И Не ЗначениеЗаполнено(ДанныеТаймера.ДатаОкончания);
КонецФункции

Функция ЕстьАктивныйТаймер(Пользователь = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Таймеры.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.Таймеры КАК Таймеры
	|ГДЕ
	|	Таймеры.Пользователь = &Пользователь
	|	И Таймеры.ДатаНачала <> ДАТАВРЕМЯ(1, 1, 1)
	|	И Таймеры.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)";

	Если ЗначениеЗаполнено(Пользователь) Тогда
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Иначе
		Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	КонецЕсли;

	Результат = Запрос.Выполнить();

	Возврат Не Результат.Пустой();

КонецФункции

Функция ТекущиеТаймерыПользователя(Пользователь = Неопределено, ПредметДляОтбора = Неопределено,
	ДанныеДляРаботыНаКлиенте = Ложь) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таймеры.Идентификатор КАК Идентификатор,
	|	Таймеры.Пользователь КАК Пользователь,
	|	Таймеры.Предмет КАК Предмет,
	|	Таймеры.ДатаНачала КАК ДатаНачала,
	|	Таймеры.ДатаОкончания КАК ДатаОкончания,
	|	Таймеры.Часов КАК Часов,
	|	Таймеры.СчетчикЗапусков КАК СчетчикЗапусков,
	|	Таймеры.Комментарий КАК Комментарий,
	|	Таймеры.ВидДеятельности КАК ВидДеятельности,
	|	Таймеры.ДатаСозданияВМилисекундах КАК ДатаСозданияВМилисекундах
	|ИЗ
	|	РегистрСведений.Таймеры КАК Таймеры
	|ГДЕ
	|	Таймеры.Пользователь = &Пользователь
	|	И ВЫБОР
	|		КОГДА &ОтборПоПредмету
	|			ТОГДА Таймеры.Предмет = &ПредметДляОтбора
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|УПОРЯДОЧИТЬ ПО
	|	ДатаСозданияВМилисекундах";

	Если ЗначениеЗаполнено(Пользователь) Тогда
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Иначе
		Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	КонецЕсли;
	Запрос.УстановитьПараметр("ПредметДляОтбора", ПредметДляОтбора);
	Запрос.УстановитьПараметр("ОтборПоПредмету", ПредметДляОтбора <> Неопределено);

	ТаблицаТаймеров = Запрос.Выполнить().Выгрузить();

	Если ДанныеДляРаботыНаКлиенте Тогда
		ТаблицаТаймеров = ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаТаймеров);
	КонецЕсли;

	Возврат ТаблицаТаймеров;

КонецФункции

Функция ИдентификаторТаймераПоПредмету(Предмет, Пользователь = Неопределено) Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Таймеры.Идентификатор
	|ИЗ
	|	РегистрСведений.Таймеры КАК Таймеры
	|ГДЕ
	|	Таймеры.Пользователь = &Пользователь
	|	И Таймеры.Предмет = &Предмет";
	Если ЗначениеЗаполнено(Пользователь) Тогда
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Иначе
		Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	КонецЕсли;
	Запрос.УстановитьПараметр("Предмет", Предмет);

	Выборка=Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Идентификатор;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ДанныеТаймера(Идентификатор) Экспорт
	Отбор=Новый Структура;
	Отбор.Вставить("Идентификатор", Идентификатор);

	ДанныеТаймера= РегистрыСведений.Таймеры.Получить(Отбор);
	ДанныеТаймера.Вставить("Идентификатор", Идентификатор);

	Возврат ДанныеТаймера;
КонецФункции


#КонецОбласти

Функция СсылкаПредметаВСтроку(Предмет) Экспорт
	Возврат ЗначениеВСтрокуВнутр(Предмет);
КонецФункции

Функция СтрокаСсылкиПредметаВЗначение(СтрокаСсылки) Экспорт
	Возврат ЗначениеИзСтрокиВнутр(СтрокаСсылки);
КонецФункции

Функция ДанныеТаймеровДляВыводаВПолеHTML() Экспорт
	ТекущиеТаймеры=ТекущиеТаймерыПользователя( , , Истина);
	ЧасовойПояс=ЧасовойПоясСеанса();

	МассивТаймеровДляПоляHTML=Новый Массив;
	Для Каждого ТекТаймер Из ТекущиеТаймеры Цикл
		НовыйТаймер=Новый Структура;
		НовыйТаймер.Вставить("id", ТекТаймер.Идентификатор);
		Если Не ЗначениеЗаполнено(ТекТаймер.ДатаНачала) Тогда
			НовыйТаймер.Вставить("start", 0);
		Иначе
			НовыйТаймер.Вставить("start", ОбщегоНазначенияКлиентСервер.ДатаUnixTimeИз1С(МестноеВремя(ТекТаймер.ДатаНачала,ЧасовойПояс)));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ТекТаймер.ДатаОкончания) Тогда
			НовыйТаймер.Вставить("end", 0);
		Иначе
			НовыйТаймер.Вставить("end", ОбщегоНазначенияКлиентСервер.ДатаUnixTimeИз1С(МестноеВремя(ТекТаймер.ДатаОкончания,ЧасовойПояс)));
		КонецЕсли;
		НовыйТаймер.Вставить("comment", ТекТаймер.Комментарий);
		НовыйТаймер.Вставить("action", Строка(ТекТаймер.ВидДеятельности));
		НовыйТаймер.Вставить("context", ПредставлениеПредметаУчетаТрудозатрат(ТекТаймер.Предмет));
		Если ЗначениеЗаполнено(ТекТаймер.Предмет) Тогда
			НовыйТаймер.Вставить("contextUrl", ПолучитьНавигационнуюСсылку(ТекТаймер.Предмет));
		Иначе
			НовыйТаймер.Вставить("contextUrl", "");
		КонецЕсли;
		НовыйТаймер.Вставить("duration", ТекТаймер.Часов);
		НовыйТаймер.Вставить("createdAt", ТекТаймер.ДатаСозданияВМилисекундах);

		МассивТаймеровДляПоляHTML.Добавить(НовыйТаймер);
	КонецЦикла;

	ДоступныеВидыДеятельностиУчетаТрудозатрат=УчетВремени.ДоступныеВидыДеятельностиУчетаТрудозатрат();

	МассивВидовДеятельности=Новый Массив;
	Для Каждого ТекВид Из ДоступныеВидыДеятельностиУчетаТрудозатрат Цикл
		СтруктураВида=Новый Структура;
		СтруктураВида.Вставить("id", Строка(ТекВид.УникальныйИдентификатор()));
		СтруктураВида.Вставить("name", Строка(ТекВид));

		МассивВидовДеятельности.Добавить(СтруктураВида);
	КонецЦикла;
	СтруктураВозврата=Новый Структура;
	СтруктураВозврата.Вставить("Таймеры", ОбщегоНазначенияКлиентСервер.ЗаписатьДанныеJSON(МассивТаймеровДляПоляHTML));
	СтруктураВозврата.Вставить("КоличествоТаймеров", ТекущиеТаймеры.Количество());
	СтруктураВозврата.Вставить("ТекущиеТаймеры", ТекущиеТаймеры);
	СтруктураВозврата.Вставить("ВидыДеятельности", ОбщегоНазначенияКлиентСервер.ЗаписатьДанныеJSON(
		МассивВидовДеятельности));
	Возврат СтруктураВозврата;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ОтразитьИзменениеТаймераУчетаВремени(Идентификатор, ПараметрыУчетаВремени) Экспорт 

	Набор = РегистрыСведений.Таймеры.СоздатьНаборЗаписей();
	Набор.Отбор.Идентификатор.Установить(Идентификатор);
	Набор.Прочитать();

	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
		Запись.Идентификатор = Идентификатор;
		Запись.Пользователь = Пользователи.ТекущийПользователь();
	Иначе
		Запись = Набор[0];
	КонецЕсли;

	ЗаполнитьЗначенияСвойств(Запись, ПараметрыУчетаВремени);

	ДобавитьПериодУчетаВремениВЗапись(Запись);

	Набор.Записать();

	Возврат Истина;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОстановитьДругиеЗапущенныеТаймеры(ИдентификаторТаймера)
	ТекущиеТаймеры=ТекущиеТаймерыПользователя();
	Для Каждого ТекТаймер Из ТекущиеТаймеры Цикл
		Если ТекТаймер.Идентификатор = ИдентификаторТаймера Тогда
			Продолжить;
		КонецЕсли;
		Если ТаймерАктивен(ТекТаймер) Тогда
			ОстановитьТаймер(ТекТаймер.Идентификатор);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Процедура ДобавитьПериодУчетаВремениВЗапись(Запись)

	Если ЗначениеЗаполнено(Запись.ДатаНачала) И ЗначениеЗаполнено(Запись.ДатаОкончания) Тогда

		СтрокаПериода = ПредставлениеПериодаУчетаВремени(Запись.ДатаНачала, Запись.ДатаОкончания);
		МассивПериодов = СтрРазделить(Запись.Периоды, " ", Ложь);
		Если МассивПериодов.Найти(СтрокаПериода) = Неопределено Тогда
			МассивПериодов.Добавить(СтрокаПериода);
			Запись.Периоды = СтрСоединить(МассивПериодов, " ");
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Функция ПредставлениеПериодаУчетаВремени(ДатаНачала, ДатаОкончания)

	Возврат СтрШаблон("[%1-%2]", Формат(ДатаНачала, "ДФ=HH:mm"), Формат(ДатаОкончания, "ДФ=HH:mm"));

КонецФункции


Функция ПредставлениеПредметаУчетаТрудозатрат(Предмет)

	Если ТипЗнч(Предмет) = Тип("ДокументСсылка.Задача") Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Предмет, "Номер,Тема,Проект");
		Представление = СтрШаблон("Задача #%1: %2 (%3)", Формат(Реквизиты.Номер, "ЧГ=0"), Реквизиты.Тема,
			Реквизиты.Проект);
	ИначеЕсли ТипЗнч(Предмет) = Тип("ДокументСсылка.ПланОбучения") Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Предмет, "Курс");
		Представление = СтрШаблон("Курс: %1; Тема: %2", Реквизиты.Курс, "");
	ИначеЕсли ТипЗнч(Предмет) = Тип("СправочникСсылка.Проекты") Тогда
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Предмет, "Наименование");
		Представление = СтрШаблон("Проект: %1", Реквизиты.Наименование);

	Иначе
		Представление = Строка(Предмет);
	КонецЕсли;

	Возврат Представление;

КонецФункции

#КонецОбласти