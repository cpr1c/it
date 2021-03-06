////////////////////////////////////////////////////////////////////////////////
// УчетВремени
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Функция ДоступныеВидыДеятельностиУчетаТрудозатрат() Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ВидыДеятельности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыДеятельности КАК ВидыДеятельности
	|ГДЕ
	|	НЕ ВидыДеятельности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыДеятельности.РеквизитДопУпорядочивания";

	Виды=Новый Массив;

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Виды.Добавить(Выборка.Ссылка);
	КонецЦикла;

	Возврат Виды;
КонецФункции

Процедура ЗафиксироватьТрудозатраты(Предмет, Часов, ВидДеятельности, Комментарий) Экспорт
	НовыйДокументТрудозатрат=Документы.Трудозатраты.СоздатьДокумент();
	НовыйДокументТрудозатрат.Автор=Пользователи.текущийПользователь();
	НовыйДокументТрудозатрат.ВидДеятельности=ВидДеятельности;
	НовыйДокументТрудозатрат.Предмет=Предмет;
	НовыйДокументТрудозатрат.Дата=ТекущаяДатаСеанса();
	НовыйДокументТрудозатрат.Комментарий=Комментарий;
	НовыйДокументТрудозатрат.Часов=Часов;
	НовыйДокументТрудозатрат.УстановитьНовыйНомер();
	НовыйДокументТрудозатрат.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры

Процедура ДобавитьКомандыБыстройУстановкиЧасов(Форма, ГруппаТрудозатраты) Экспорт

	ШкалаТрудозатрат = СтрРазделить("0;0.25;0.5;1;1.5;2;3;4", ";", Ложь);

	Для Каждого КоличествоЧасов Из ШкалаТрудозатрат Цикл

		ИмяКоманды = "УчетВремени_УстановитьЧасов_" + СтрЗаменить(КоличествоЧасов, ".", "_");
		
		// Добавляет команду на форму              
		ДобавленнаяКомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
		ДобавленнаяКомандаФормы.Действие = "Подключаемый_УчетВремени_ВыполнитьКомандуБыстройУстановкиЧасов";
		ДобавленнаяКомандаФормы.Отображение = ОтображениеКнопки.Текст;
		ДобавленнаяКомандаФормы.ИзменяетСохраняемыеДанные=Истина;
		
		// Добавляет кнопку на форму, связывает ее с добавленной командной и помещает на командную панель формы
		ДобавленнаяКнопкаФормы = Форма.Элементы.Вставить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаТрудозатраты);
		ДобавленнаяКнопкаФормы.Заголовок = КоличествоЧасов;
		ДобавленнаяКнопкаФормы.ИмяКоманды = ИмяКоманды;

	КонецЦикла;

КонецПроцедуры

Функция ТекущиеТаймерыПользователя(Пользователь = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт

	ПредметДляОтбора = Неопределено;
	ПредметДляСортировки = Неопределено;
	ДанныеДляРаботыНаКлиенте = Ложь;
	Если ДополнительныеПараметры <> Неопределено Тогда
		Если ДополнительныеПараметры.Свойство("ПредметДляОтбора") Тогда
			ПредметДляОтбора = ДополнительныеПараметры.ПредметДляОтбора;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("ПредметДляСортировки") Тогда
			ПредметДляСортировки = ДополнительныеПараметры.ПредметДляСортировки;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("ДанныеДляРаботыНаКлиенте") Тогда
			ДанныеДляРаботыНаКлиенте = ДополнительныеПараметры.ДанныеДляРаботыНаКлиенте;
		КонецЕсли;
	КонецЕсли;
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
	|	ВЫБОР
	|		КОГДА &ПредметДляСортировки = НЕОПРЕДЕЛЕНО
	|			ТОГДА 1
	|		ИНАЧЕ ВЫБОР
	|				КОГДА Таймеры.Предмет = &ПредметДляСортировки
	|					ТОГДА 0
	|				ИНАЧЕ 1
	|			КОНЕЦ
	|	КОНЕЦ КАК ПорядокПоПредмету,
	|	ВЫБОР
	|		КОГДА Таймеры.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ПорядокПоЗавершению
	|ИЗ
	|	РегистрСведений.Таймеры КАК Таймеры
	|ГДЕ
	|	Таймеры.Пользователь = &Пользователь
	|	И ВЫБОР
	|			КОГДА &ОтборПоПредмету
	|				ТОГДА Таймеры.Предмет = &ПредметДляОтбора
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокПоПредмету,
	|	ПорядокПоЗавершению,
	|	ДатаОкончания УБЫВ,
	|	ДатаНачала";

	Если ЗначениеЗаполнено(Пользователь) Тогда
		Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Иначе
		Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	КонецЕсли;
	Запрос.УстановитьПараметр("ПредметДляОтбора", ПредметДляОтбора);
	Запрос.УстановитьПараметр("ОтборПоПредмету", ЗначениеЗаполнено(ПредметДляОтбора));
	Запрос.УстановитьПараметр("ПредметДляСортировки", ПредметДляСортировки);

	ТаблицаТаймеров = Запрос.Выполнить().Выгрузить();

	Если ДанныеДляРаботыНаКлиенте Тогда
		ТаблицаТаймеров = ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаТаймеров);
	КонецЕсли;

	Возврат ТаблицаТаймеров;

КонецФункции

Функция ТаймерПоПредмету(Предмет) Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Таймеры.Идентификатор
	|ИЗ
	|	РегистрСведений.Таймеры КАК Таймеры
	|ГДЕ
	|	Таймеры.Пользователь = &Пользователь
	|	И Таймеры.Предмет = &Предмет";
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("Предмет", Предмет);

	Выборка=Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Идентификатор;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ЗафиксироватьОкончаниеРаботПоТекущимТаймерам(ТекущиеТаймеры, ПараметрыУчетаВремени) Экспорт

	НачатьТранзакцию();

	Для Каждого ПараметрыТаймера Из ТекущиеТаймеры Цикл

		Набор = РегистрыСведений.Таймеры.СоздатьНаборЗаписей();
		Набор.Отбор.Идентификатор.Установить(ПараметрыТаймера.Идентификатор);
		Набор.Прочитать();

		Если Набор.Количество() = 1 Тогда

			Запись = Набор[0];

			Продолжительность = УчетВремениКлиентСервер.РазностьДатВЧасах(Запись.ДатаНачала,
				ПараметрыУчетаВремени.ДатаОкончания);

			ПараметрыТаймера.Вставить("Часов", Продолжительность);

			Запись.ДатаОкончания = ПараметрыУчетаВремени.ДатаОкончания;
			Запись.Часов = Запись.Часов + Продолжительность;

			ДобавитьПериодУчетаВремениВЗапись(Запись);

			Набор.Записать();

		КонецЕсли;

	КонецЦикла;

	ЗафиксироватьТранзакцию();

	Возврат Истина;

КонецФункции

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

Функция ВедетсяУчетВремени() Экспорт

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

	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());

	Результат = Запрос.Выполнить();

	Возврат Не Результат.Пустой();

КонецФункции

Функция ПериодыУчетаВремениПоТаймеру(Идентификатор) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таймеры.Периоды КАК Периоды
	|ИЗ
	|	РегистрСведений.Таймеры КАК Таймеры
	|ГДЕ
	|	Таймеры.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Периоды;
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

Процедура СоздатьЭлементыТекущихТаймеровНаФорме(Форма, ГруппаТаймеров) Экспорт
	Таймеры=ТекущиеТаймерыПользователя();
	ТекущиеТаймерыФормы=Новый Массив;

	ТекДата = ТекущаяДатаСеанса();
	ВидДеятельностиПоУмолчанию = Справочники.ВидыДеятельности.ПолучитьВидДеятельностиПоУмолчанию();
	ПрефиксЭлементов=УчетВремениКлиентСервер.ПрефиксЭлементовФормы();

	Для Каждого Эл Из ГруппаТаймеров.ПодчиненныеЭлементы Цикл
		ТекущиеТаймерыФормы.Добавить(УчетВремениКлиентСервер.ИдентификаторТаймераПоИмениГруппыТаймера(Эл.Имя));
	КонецЦикла;
	
	
//	УдалитьПодчиненныеЭлементыГруппыФормы(Форма, ГруппаТаймеров, Ложь);

	ДобавитьРеквизитыСДаннымиТаймеровНаФорму(Форма, Таймеры, ТекущиеТаймерыФормы);

	МассивТекущихИдентификаторовТаймеров=Новый Массив;

	Для Каждого ТекТаймер Из Таймеры Цикл
		МассивТекущихИдентификаторовТаймеров.Добавить(ТекТаймер.Идентификатор);
		Идентификатор=СтрЗаменить(ТекТаймер.Идентификатор, "-", "_");

		ИмяГруппыТаймера=УчетВремениКлиентСервер.ИмяГруппыТаймера(ТекТаймер.Идентификатор);

		ГруппаТаймеровПоПредмету=Форма.Элементы.Найти(ИмяГруппыТаймера);
		Если ГруппаТаймеровПоПредмету = Неопределено Тогда
			ПредставлениеПредмета = ПредставлениеПредметаУчетаТрудозатрат(ТекТаймер.Предмет);

			ГруппаТаймеровПоПредмету = Форма.Элементы.Добавить(ИмяГруппыТаймера, Тип(
			"ГруппаФормы"), ГруппаТаймеров);
			ГруппаТаймеровПоПредмету.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаТаймеровПоПредмету.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			ГруппаТаймеровПоПредмету.Заголовок   = ПредставлениеПредмета;
			ГруппаТаймеровПоПредмету.ЗаголовокСвернутогоОтображения = ПредставлениеПредмета;
			ГруппаТаймеровПоПредмету.Поведение   = ПоведениеОбычнойГруппы.Свертываемая;
			ГруппаТаймеровПоПредмету.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
			ДобавитьЭлементыТекущегоТаймераНаФорму(Форма, ГруппаТаймеровПоПредмету, ТекТаймер, Идентификатор, ТекДата);

			Форма[ПрефиксЭлементов + "Комментарий_" + Идентификатор] = ТекТаймер.Комментарий;
			Форма[ПрефиксЭлементов + "ВидДеятельности_" + Идентификатор] = ТекТаймер.ВидДеятельности;
		КонецЕсли;

		Форма[ПрефиксЭлементов + "ДатаНачала_" + Идентификатор] = ТекТаймер.ДатаНачала;
		Форма[ПрефиксЭлементов + "ДатаОкончания_" + Идентификатор] = ТекТаймер.ДатаОкончания;
		Форма[ПрефиксЭлементов + "Часов_" + Идентификатор] = ТекТаймер.Часов;
		
		УчетВремениКлиентСервер.УстановитьОформлениеТаймера(Форма, Идентификатор);
		УчетВремениКлиентСервер.ОбновитьОтображениеВремениТаймера(Форма, ТекТаймер, Идентификатор);
	КонецЦикла;

	МассивЭлементовКУдалению=Новый Массив;
	Для Каждого ИдТаймера Из ТекущиеТаймерыФормы Цикл
		Если МассивТекущихИдентификаторовТаймеров.Найти(ИдТаймера) = Неопределено Тогда
			МассивЭлементовКУдалению.Добавить(ИдТаймера);
		КонецЕсли;
	КонецЦикла;

	Для Каждого ИдТаймера Из МассивЭлементовКУдалению Цикл
		ИмяГруппыТаймера=УчетВремениКлиентСервер.ИмяГруппыТаймера(ИдТаймера);
		УдалитьПодчиненныеЭлементыГруппыФормы(Форма, Форма.Элементы[ИмяГруппыТаймера], Истина);
	КонецЦикла;
КонецПроцедуры

Функция ДанныеТаймера(Идентификатор) Экспорт
	Отбор=Новый Структура;
	Отбор.Вставить("Идентификатор", Идентификатор);

	ДанныеТаймера= РегистрыСведений.Таймеры.Получить(Отбор);
	ДанныеТаймера.Вставить("Идентификатор", Идентификатор);
//	ДанныеТаймера.Вставить("Остановлен", УчетВремениКлиентСервер.ТаймерОстановлен(ДанныеТаймера));
//	ДанныеТаймера.Вставить("Активен", УчетВремениКлиентСервер.ТаймерАктивен(ДанныеТаймера));

	Возврат ДанныеТаймера;
КонецФункции

Функция СоздатьИСтартоватьТаймер(Предмет) Экспорт
	Идентификатор=ТаймерПоПредмету(Предмет);
	Если Идентификатор = Неопределено Тогда
		Идентификатор=СоздатьТаймер(Предмет);
	КонецЕсли;

	СтартоватьТаймер(Идентификатор);

	Возврат Идентификатор;
КонецФункции

Процедура СтартоватьТаймер(Идентификатор) Экспорт
	ДанныеТаймера=ДанныеТаймера(Идентификатор);

	Если УчетВремениКлиентСервер.ТаймерАктивен(ДанныеТаймера) Тогда
		Возврат;
	КонецЕсли;
	ОстановитьДругиеЗапущенныеТаймеры(ДанныеТаймера);

	ДанныеТаймера.ДатаНачала = ТекущаяДатаСеанса();
	ДанныеТаймера.ДатаОкончания = '00010101000000';
	ДанныеТаймера.СчетчикЗапусков = ДанныеТаймера.СчетчикЗапусков + 1;
	ОтразитьИзменениеТаймераУчетаВремени(Идентификатор, ДанныеТаймера);

КонецПроцедуры

Функция СоздатьТаймер(Предмет) Экспорт
	НовыйТаймер=РегистрыСведений.Таймеры.СоздатьМенеджерЗаписи();
	НовыйТаймер.Идентификатор=Строка(Новый УникальныйИдентификатор);
	НовыйТаймер.Пользователь=Пользователи.ТекущийПользователь();
	НовыйТаймер.Предмет=Предмет;
//	НовыйТаймер.ДатаНачала=ТекущаяДатаСеанса();
//	НовыйТаймер.СчетчикЗапусков=1;
	НовыйТаймер.ВидДеятельности=Справочники.ВидыДеятельности.ПолучитьВидДеятельностиПоУмолчанию();
	НовыйТаймер.Записать(Истина);

	Возврат НовыйТаймер.Идентификатор;

КонецФункции

Процедура ОстановитьТаймер(Идентификатор) Экспорт
	ДанныеТаймера=ДанныеТаймера(Идентификатор);

	ДанныеТаймера.ДатаОкончания = ТекущаяДатаСеанса();
	ДанныеТаймера.Часов = ДанныеТаймера.Часов + УчетВремениКлиентСервер.РазностьДатВЧасах(ДанныеТаймера.ДатаНачала,
		ДанныеТаймера.ДатаОкончания);
	ОтразитьИзменениеТаймераУчетаВремени(Идентификатор, ДанныеТаймера);

КонецПроцедуры

Процедура УдалитьТаймер(Идентификатор) Экспорт
	Набор = РегистрыСведений.Таймеры.СоздатьНаборЗаписей();
	Набор.Отбор.Идентификатор.Установить(Идентификатор);
	Набор.Записать(Истина);
КонецПроцедуры

Процедура СоздатьЭлементыТаймераНаФормеЗадачи(Форма, ГруппаТаймера) Экспорт
	Идентификатор=ТаймерПоПредмету(Форма.Объект.Ссылка);
	

//	Таймеры=ТекущиеТаймерыПользователя();
//	ТекущиеТаймерыФормы=Новый Массив;
//
//	ТекДата = ТекущаяДатаСеанса();
//	ВидДеятельностиПоУмолчанию = Справочники.ВидыДеятельности.ПолучитьВидДеятельностиПоУмолчанию();
//	ПрефиксЭлементов=УчетВремениКлиентСервер.ПрефиксЭлементовФормы();
//
//	Для Каждого Эл Из ГруппаТаймеров.ПодчиненныеЭлементы Цикл
//		ТекущиеТаймерыФормы.Добавить(УчетВремениКлиентСервер.ИдентификаторТаймераПоИмениГруппыТаймера(Эл.Имя));
//	КонецЦикла;
//	
//	
////	УдалитьПодчиненныеЭлементыГруппыФормы(Форма, ГруппаТаймеров, Ложь);
//
//	ДобавитьРеквизитыСДаннымиТаймеровНаФорму(Форма, Таймеры, ТекущиеТаймерыФормы);
//
//	МассивТекущихИдентификаторовТаймеров=Новый Массив;
//
//	Для Каждого ТекТаймер Из Таймеры Цикл
//		МассивТекущихИдентификаторовТаймеров.Добавить(ТекТаймер.Идентификатор);
//		Идентификатор=СтрЗаменить(ТекТаймер.Идентификатор, "-", "_");
//
//		ИмяГруппыТаймера=УчетВремениКлиентСервер.ИмяГруппыТаймера(ТекТаймер.Идентификатор);
//
//		ГруппаТаймеровПоПредмету=Форма.Элементы.Найти(ИмяГруппыТаймера);
//		Если ГруппаТаймеровПоПредмету = Неопределено Тогда
//			ПредставлениеПредмета = ПредставлениеПредметаУчетаТрудозатрат(ТекТаймер.Предмет);
//
//			ГруппаТаймеровПоПредмету = Форма.Элементы.Добавить(ИмяГруппыТаймера, Тип(
//			"ГруппаФормы"), ГруппаТаймеров);
//			ГруппаТаймеровПоПредмету.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
//			ГруппаТаймеровПоПредмету.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
//			ГруппаТаймеровПоПредмету.Заголовок   = ПредставлениеПредмета;
//			ГруппаТаймеровПоПредмету.ЗаголовокСвернутогоОтображения = ПредставлениеПредмета;
//			ГруппаТаймеровПоПредмету.Поведение   = ПоведениеОбычнойГруппы.Свертываемая;
//			ГруппаТаймеровПоПредмету.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
//			ДобавитьЭлементыТекущегоТаймераНаФорму(Форма, ГруппаТаймеровПоПредмету, ТекТаймер, Идентификатор, ТекДата);
//
//			Форма[ПрефиксЭлементов + "Комментарий_" + Идентификатор] = ТекТаймер.Комментарий;
//			Форма[ПрефиксЭлементов + "ВидДеятельности_" + Идентификатор] = ТекТаймер.ВидДеятельности;
//		КонецЕсли;
//
//		Форма[ПрефиксЭлементов + "ДатаНачала_" + Идентификатор] = ТекТаймер.ДатаНачала;
//		Форма[ПрефиксЭлементов + "ДатаОкончания_" + Идентификатор] = ТекТаймер.ДатаОкончания;
//		Форма[ПрефиксЭлементов + "Часов_" + Идентификатор] = ТекТаймер.Часов;
//		
//		УчетВремениКлиентСервер.УстановитьОформлениеТаймера(Форма, Идентификатор);
//		УчетВремениКлиентСервер.ОбновитьОтображениеВремениТаймера(Форма, ТекТаймер, Идентификатор);
//	КонецЦикла;
//
//	МассивЭлементовКУдалению=Новый Массив;
//	Для Каждого ИдТаймера Из ТекущиеТаймерыФормы Цикл
//		Если МассивТекущихИдентификаторовТаймеров.Найти(ИдТаймера) = Неопределено Тогда
//			МассивЭлементовКУдалению.Добавить(ИдТаймера);
//		КонецЕсли;
//	КонецЦикла;
//
//	Для Каждого ИдТаймера Из МассивЭлементовКУдалению Цикл
//		ИмяГруппыТаймера=УчетВремениКлиентСервер.ИмяГруппыТаймера(ИдТаймера);
//		УдалитьПодчиненныеЭлементыГруппыФормы(Форма, Форма.Элементы[ИмяГруппыТаймера], Истина);
//	КонецЦикла;
КонецПроцедуры


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОстановитьДругиеЗапущенныеТаймеры(ДанныеТаймера)
	ТекущиеТаймеры=ТекущиеТаймерыПользователя();
	Для Каждого ТекТаймер Из ТекущиеТаймеры Цикл
		Если ТекТаймер.Идентификатор = ДанныеТаймера.Идентификатор Тогда
			Продолжить;
		КонецЕсли;
		Если УчетВремениКлиентСервер.ТаймерАктивен(ТекТаймер) Тогда
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

Процедура ДобавитьРеквизитыСДаннымиТаймеровНаФорму(Форма, Таймеры, ТекущиеТаймерыФормы)
	Префикс=УчетВремениКлиентСервер.ПрефиксЭлементовФормы();

	МассивДобавляемыхРеквизитов = Новый Массив;
	МассивУдаляемыхРеквизитов=Новый Массив;

	МассивИдентификаторовТекущихТАймеров=Новый Массив;

	ИдентификаторыТаймеров = ОбщегоНазначения.ВыгрузитьКолонку(Таймеры, "Идентификатор", Истина);

	Для Каждого Идентификатор Из ИдентификаторыТаймеров Цикл

		Ид = СтрЗаменить(Идентификатор, "-", "_");
		МассивИдентификаторовТекущихТАймеров.Добавить(Идентификатор);

		Если ТекущиеТаймерыФормы.Найти(Идентификатор) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ДобавленныйРеквизит = Новый РеквизитФормы(Префикс + "ВидДеятельности_" + Ид,
			Новый ОписаниеТипов("СправочникСсылка.ВидыДеятельности"));
		МассивДобавляемыхРеквизитов.Добавить(ДобавленныйРеквизит);

		ДобавленныйРеквизит = Новый РеквизитФормы(Префикс + "Комментарий_" + Ид, Новый ОписаниеТипов("Строка", , , ,
			Новый КвалификаторыСтроки(255)));
		МассивДобавляемыхРеквизитов.Добавить(ДобавленныйРеквизит);

		ДобавленныйРеквизит = Новый РеквизитФормы(Префикс + "ДатаНачала_" + Ид, Новый ОписаниеТипов("Дата", , ,
			Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя), ));
		МассивДобавляемыхРеквизитов.Добавить(ДобавленныйРеквизит);
		ДобавленныйРеквизит = Новый РеквизитФормы(Префикс + "ДатаОкончания_" + Ид, Новый ОписаниеТипов("Дата", , ,
			Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя), ));
		МассивДобавляемыхРеквизитов.Добавить(ДобавленныйРеквизит);
		ДобавленныйРеквизит = Новый РеквизитФормы(Префикс + "Часов_" + Ид, Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 2)));
		МассивДобавляемыхРеквизитов.Добавить(ДобавленныйРеквизит);
	КонецЦикла;

	Для Каждого Идентификатор Из ТекущиеТаймерыФормы Цикл
		Если МассивИдентификаторовТекущихТАймеров.Найти(Идентификатор) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		МассивУдаляемыхРеквизитов.Добавить(Префикс + "ВидДеятельности_" + СтрЗаменить(Идентификатор, "-", "_"));
		МассивУдаляемыхРеквизитов.Добавить(Префикс + "Комментарий_" + СтрЗаменить(Идентификатор, "-", "_"));
		МассивУдаляемыхРеквизитов.Добавить(Префикс + "ДатаНачала_" + СтрЗаменить(Идентификатор, "-", "_"));
		МассивУдаляемыхРеквизитов.Добавить(Префикс + "ДатаОкончания_" + СтрЗаменить(Идентификатор, "-", "_"));
		МассивУдаляемыхРеквизитов.Добавить(Префикс + "Часов_" + СтрЗаменить(Идентификатор, "-", "_"));
	КонецЦикла;

	Если МассивДобавляемыхРеквизитов.Количество() > 0 Или МассивУдаляемыхРеквизитов.Количество() > 0 Тогда
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, МассивУдаляемыхРеквизитов);
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЭлементыТекущегоТаймераНаФорму(Форма, ГруппаТаймеры, ДанныеТаймера, Ид, ТекДата)
	Префикс=УчетВремениКлиентСервер.ПрефиксЭлементовФормы();

	ГруппаНовогоТаймера = Форма.Элементы.Добавить(Префикс + "Группа_" + Ид, Тип("ГруппаФормы"), ГруппаТаймеры);
	ГруппаНовогоТаймера.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаНовогоТаймера.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ГруппаНовогоТаймера.ОтображатьЗаголовок   = Ложь;

	Строка1 = Форма.Элементы.Добавить(Префикс + "Строка1_" + Ид, Тип("ГруппаФормы"), ГруппаНовогоТаймера);
	Строка1.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
	Строка1.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	Строка1.ОтображатьЗаголовок   = Ложь;

	НадписьДатаНачала = Форма.Элементы.Добавить(Префикс + "НадписьДатаНачала_" + Ид, Тип("ДекорацияФормы"), Строка1);
	НадписьДатаОкончания = Форма.Элементы.Добавить(Префикс + "НадписьДатаОкончания_" + Ид, Тип("ДекорацияФормы"),
		Строка1);
	НадписьПродолжительность = Форма.Элементы.Добавить(Префикс + "НадписьПродолжительность_" + Ид, Тип(
		"ДекорацияФормы"), Строка1);

	Кнопка = КнопкаДобавленнойКомандыФормы(Форма, Префикс + "Старт_" + Ид, "Начать учет времени", Строка1);
	Кнопка.Картинка = БиблиотекаКартинок.ТаймерСтарт;
	Кнопка.Отображение = ОтображениеКнопки.Картинка;
	Кнопка.Ширина = 3;

	Кнопка = КнопкаДобавленнойКомандыФормы(Форма, Префикс + "Стоп_" + Ид, "Остановить учет времени", Строка1);
	Кнопка.Картинка = БиблиотекаКартинок.ТаймерСтоп;
	Кнопка.Отображение = ОтображениеКнопки.Картинка;
	Кнопка.Ширина = 3;

	Кнопка = КнопкаДобавленнойКомандыФормы(Форма, Префикс + "Зафиксировать_" + Ид, "Зафиксировать учет времени",
		Строка1);
	Кнопка.Картинка = БиблиотекаКартинок.ТаймерЗафиксировать;
	Кнопка.Отображение = ОтображениеКнопки.Картинка;
	Кнопка.Ширина = 3;

	Кнопка = КнопкаДобавленнойКомандыФормы(Форма, Префикс + "Отмена_" + Ид, "Отменить учет времени", Строка1);
	Кнопка.Картинка = БиблиотекаКартинок.ТаймерОтменить;
	Кнопка.Отображение = ОтображениеКнопки.Картинка;
	Кнопка.Ширина = 3;

	Кнопка = КнопкаДобавленнойКомандыФормы(Форма, Префикс + "ОткрытьПредмет_" + Ид, "Открыть предмет", Строка1);
	Кнопка.Отображение = ОтображениеКнопки.Текст;
	Строка2 = Форма.Элементы.Добавить(Префикс + "Строка2_" + Ид, Тип("ГруппаФормы"), ГруппаНовогоТаймера);
	Строка2.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
	Строка2.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	Строка2.ОтображатьЗаголовок   = Ложь;

	Поле = Форма.Элементы.Добавить(Префикс + "ВидДеятельности_" + Ид, Тип("ПолеФормы"), Строка2);
	Поле.Заголовок = "Вид деятельности";
	Поле.ПутьКДанным = Префикс + "ВидДеятельности_" + Ид;
	Поле.Вид = ВидПоляФормы.ПолеВвода;
	Поле.УстановитьДействие("ПриИзменении", "Подключаемый_УчетВремени_РеквизитТаймераПриИзменении");

	Строка3 = Форма.Элементы.Добавить(Префикс + "Строка3_" + Ид, Тип("ГруппаФормы"), ГруппаНовогоТаймера);
	Строка3.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
	Строка3.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	Строка3.ОтображатьЗаголовок   = Ложь;

	Поле = Форма.Элементы.Добавить(Префикс + "Комментарий_" + Ид, Тип("ПолеФормы"), Строка3);
	Поле.Заголовок = "Комментарий";
	Поле.ПутьКДанным = Префикс + "Комментарий_" + Ид;
	Поле.Вид = ВидПоляФормы.ПолеВвода;
	Поле.АвтоМаксимальнаяШирина = Ложь;
	Поле.УстановитьДействие("ПриИзменении", "Подключаемый_УчетВремени_РеквизитТаймераПриИзменении");

КонецПроцедуры

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

Функция КнопкаДобавленнойКомандыФормы(Форма, ИмяКоманды, ЗаголовокКоманды, Группа)

	НоваяКоманда=Форма.Команды.Найти(ИмяКоманды);
	Если НоваяКоманда = Неопределено Тогда
		НоваяКоманда = Форма.Команды.Добавить(ИмяКоманды);
		НоваяКоманда.Подсказка = ЗаголовокКоманды;
		НоваяКоманда.Действие = "Подключаемый_УчетВремени_ОбработатьКомандуУчетаВремени";
	КонецЕсли;

	Кнопка = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), Группа);
	Кнопка.ИмяКоманды = ИмяКоманды;
	Кнопка.Заголовок = ЗаголовокКоманды;

	Возврат Кнопка;

КонецФункции

Процедура УдалитьПодчиненныеЭлементыГруппыФормы(Форма, ГруппаФормы, УдалятьЭлемент = Ложь)
	Если ТипЗнч(ГруппаФормы) = Тип("ГруппаФормы") Тогда
		МассивЭлементов=Новый Массив;
		Для Каждого Эл Из ГруппаФормы.ПодчиненныеЭлементы Цикл
			МассивЭлементов.Добавить(Эл);
		КонецЦикла;
		Для Каждого Эл Из МассивЭлементов Цикл
			УдалитьПодчиненныеЭлементыГруппыФормы(Форма, Эл, Истина);
		КонецЦикла;
	КонецЕсли;

	Если УдалятьЭлемент Тогда
		Форма.Элементы.Удалить(ГруппаФормы);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти