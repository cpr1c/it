#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСтатусыПоУмолчанию();
	ЗаполнитьДеревоЗадач();
	УстановитьУсловноеОформлениеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	//TODO: Вставить содержимое обработчика
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗначенияДляВыбора = УправлениеЗадачамиПовтИсп.УпорядоченныйСписокСтатусов();
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отмеченные", Статусы);
	ПараметрыОткрытия.Вставить("ОписаниеТипов", Новый ОписаниеТипов("СправочникСсылка.СтатусыЗадач"));
	ПараметрыОткрытия.Вставить("ЗначенияДляВыбора", ЗначенияДляВыбора);
	ПараметрыОткрытия.Вставить("ЗначенияДляВыбораЗаполнены", Элемент.СписокВыбора.Количество() > 0);
//	ПараметрыОткрытия.Вставить("ОграничиватьВыборУказаннымиЗначениями", ПараметрыОткрытия.ЗначенияДляВыбораЗаполнены);
	ПараметрыОткрытия.Вставить("Представление", Элемент.Заголовок);
//	ПараметрыОткрытия.Вставить("ПараметрыВыбора", Новый Массив(С));
	ПараметрыОткрытия.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	
	Обработчик = Новый ОписаниеОповещения("СтатусыНачалоВыбораЗавершение", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	
	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыОткрытия, ЭтотОбъект,,,, Обработчик, Режим);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачи

&НаКлиенте
Процедура ЗадачиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ТекДанные = Элементы.Задачи.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Задачи.ТекущийЭлемент = Элементы.ЗадачиПометка Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные.Изменено = Истина;
	ТекДанные.Пометка = Истина;
	ЗадачиПометкаПриИзмененииНаСервере(ТекДанные.ПолучитьИдентификатор());
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПометкаПриИзменении(Элемент)
	ЗадачиПометкаПриИзмененииНаСервере(Элементы.Задачи.ТекущаяСтрока);
КонецПроцедуры


&НаКлиенте
Процедура ЗадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтрокаТЧ = Задачи.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если СтрокаТЧ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ЗадачиНомер" Тогда
		ПоказатьЗначение(Новый ОписаниеОповещения("ОткрытиеЗадачиЗавершение", ЭтотОбъект), СтрокаТЧ.Задача);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьСписокЗадач(Команда)
	ЗаполнитьДеревоЗадач();
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьИзмененияЗадач(Команда)
	ПрименитьИзмененияЗадачНаСервере();
КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытиеЗадачиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуПодчиненныхСтрок(ТекущаяСтрока, Пометка)
	Для Каждого СтрокаТЧ ИЗ ТекущаяСтрока.ПолучитьЭлементы() Цикл
		УстановитьПометкуПодчиненныхСтрок(СтрокаТЧ, Пометка);
		
		СтрокаТЧ.Пометка = Пометка;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуРодительскихЭлементов(ТекущаяСтрока)
	Родитель = ТекущаяСтрока.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ЕстьПометка = Ложь;
	Для Каждого Стр ИЗ Родитель.ПолучитьЭлементы() Цикл
		Если Стр.Пометка Тогда
			ЕстьПометка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Родитель.Пометка = ЕстьПометка;
	
	УстановитьПометкуРодительскихЭлементов(Родитель);
КонецПроцедуры


&НаСервере
Процедура ЗадачиПометкаПриИзмененииНаСервере(ТекущаяСтрока)
	СтрокаТЧ = Задачи.НайтиПоИдентификатору(ТекущаяСтрока);
	Если СтрокаТЧ = Неопределено Тогда
		Возврат;
	КонецЕсли;

	УстановитьПометкуПодчиненныхСтрок(СтрокаТЧ, СтрокаТЧ.Пометка);
	УстановитьПометкуРодительскихЭлементов(СтрокаТЧ);
КонецПроцедуры

&НаСервере
Процедура ПрименитьИзмененияЗадачНаСервере()
	//TODO: Вставить содержимое обработчика
КонецПроцедуры


&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	УсловноеОформление.Элементы.Очистить();
	
	// Уровень исполнителя
	НовыйЭлементОформления = УсловноеОформление.Элементы.Добавить();
	НовыйЭлементОформления.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НовыйЭлементОформления.Отбор, "Задачи.Уровень", 0);
	НовыйЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);	

	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиНомер");
	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиТема");
	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиПартнер");
	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиПроект");
	
	// Уровень проект
	НовыйЭлементОформления = УсловноеОформление.Элементы.Добавить();
	НовыйЭлементОформления.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НовыйЭлементОформления.Отбор, "Задачи.Уровень", 1);
	НовыйЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);	

	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиНомер");
	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиТема");
	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиПартнер");
	ДобавитьПолеОформления(НовыйЭлементОформления, "ЗадачиИсполнитель");
	
	// Измененные строки
	НовыйЭлементОформления = УсловноеОформление.Элементы.Добавить();
	НовыйЭлементОформления.Использование = Истина;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НовыйЭлементОформления.Отбор, "Задачи.Изменено", Истина);
	НовыйЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЖелтыйЗолотистый);	

	ДобавитьПолеОформления(НовыйЭлементОформления, "Задачи");
	
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПолеОформления(ЭлементОформления, ИмяПоля)
	НовоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	НовоеПоле.Использование = Истина;
	НовоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоЗадач()
	Задачи.ПолучитьЭлементы().Очистить();
	
	ЗАпрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	Задача.Ссылка КАК Задача,
	|	Задача.Исполнитель КАК Исполнитель,
	|	Задача.ОценкаТрудозатрат КАК ОценкаТрудозатрат,
	|	Задача.ВидОплаты КАК ВидОплаты,
	|	Задача.КонтактОбращения КАК КонтактОбращения,
	|	Задача.Проект КАК Проект,
	|	Задача.Спринт КАК Спринт,
	|	Задача.Статус КАК Статус,
	|	Задача.Тема КАК Тема,
	|	Задача.КатегорияЗакрытия КАК КатегорияЗакрытия,
	|	Задача.Номер КАК Номер,
	|	Задача.ДатаЗакрытия КАК ДатаЗакрытия,
	|	Задача.ДатаВыполнения КАК ДатаВыполнения,
	|	Задача.Проект.Партнер КАК Партнер,
	|	ЕСТЬNULL(ТрудозатратыОбороты.ФактОборот, 0) КАК ФактическиеТрудозатраты
	|ИЗ
	|	Документ.Задача КАК Задача
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.Трудозатраты.Обороты КАК ТрудозатратыОбороты
	|		ПО Задача.Ссылка = ТрудозатратыОбороты.Предмет
	|ГДЕ
	|	Задача.Статус В (&Статусы)
	|	И Задача.ДатаЗакрытия >= &ДатаНачалаУчета
	|ИТОГИ
	|ПО
	|	Исполнитель,
	|	Проект";
	Запрос.УстановитьПараметр("ДатаНачалаУчета", Константы.ДатаНачалаФормированияЗаказов.Получить());
	Запрос.УстановитьПараметр("Статусы",Статусы);
	
	ВыборкаИсполнитель=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИсполнитель.Следующий() ЦИкл
		СтрокаИсполнитель=Задачи.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаИсполнитель,ВыборкаИсполнитель);
		СтрокаИсполнитель.Уровень = 0;
		
		ВыборкаПроект = ВыборкаИсполнитель.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПроект.Следующий() Цикл
			СтрокаПроект = СтрокаИсполнитель.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПроект, ВыборкаПроект);
			СтрокаПроект.Уровень = 1;
			
			Выборка = ВыборкаПроект.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока Выборка.Следующий() Цикл
				НС = СтрокаПроект.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(НС, Выборка);
				НС.Уровень = 2;
			КонецЦикла;	
		КонецЦикла;
	КонецЦикла;		
КонецПроцедуры




&НаСервере
Процедура ЗаполнитьСтатусыПоУмолчанию()
	Запрос = Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	СтатусыЗадач.Ссылка,
	|	СтатусыЗадач.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	СтатусыЗадач.Наименование КАК Наименование
	|ИЗ
	|	Справочник.СтатусыЗадач КАК СтатусыЗадач
	|ГДЕ
	|	СтатусыЗадач.Вид В (&Вид)
	|	И НЕ СтатусыЗадач.ПометкаУдаления
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания,
	|	Наименование";
	ВидыСтатусов = Новый Массив;
	ВидыСтатусов.Добавить(Перечисления.ВидыСтатусовЗадач.Выполнена);
	ВидыСтатусов.Добавить(Перечисления.ВидыСтатусовЗадач.Закрыта);
	ВидыСтатусов.Добавить(Перечисления.ВидыСтатусовЗадач.Отклонена);
	Запрос.УстановитьПараметр("Вид", ВидыСтатусов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Статусы.Добавить(Выборка.Ссылка);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СтатусыНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Статусы.Очистить();
	Для Каждого Элемент Из Результат Цикл
		Если Не Элемент.Пометка	Тогда
			Продолжить;
		КонецЕсли;
		
		Статусы.Добавить(Элемент.Значение);
	КонецЦикла;

	ЗаполнитьДеревоЗадач();
КонецПроцедуры

#КонецОбласти