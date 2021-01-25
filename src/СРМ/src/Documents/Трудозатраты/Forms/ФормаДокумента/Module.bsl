#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Параметры.Свойство("Идентификатор", ИдентификаторТаймера);
	
	ЗаполнитьСписокВыбораДеятельности();
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если Не ЗначениеЗаполнено(Объект.ВидДеятельности) Тогда
			Объект.ВидДеятельности = Элементы.ВидДеятельности.СписокВыбора[0].Значение;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИдентификаторТаймера) Тогда
			Объект.Комментарий = Объект.Комментарий + " " + УчетВремени.ПериодыУчетаВремениПоТаймеру(ИдентификаторТаймера);	
		КонецЕсли;
		
	КонецЕсли;
	
	ДобавитьКомандыБыстройУстановкиЧасов();
	
	ОбновитьТекстКоммита();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзменилисьТрудозатраты",Объект.Предмет);
	Оповестить("ЗафиксированыТрудозатратыПоТаймеру",ИдентификаторТаймера);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЧасовРегулирование(Элемент, Направление, СтандартнаяОбработка)
	УправлениеЗадачамиКлиент.ПолеЧасовРегулирование(ЭтотОбъект, "Объект.Часов", Направление, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ОбновитьТекстКоммита();
КонецПроцедуры

&НаКлиенте
Процедура ПредметПриИзменении(Элемент)
	ОбновитьТекстКоммита();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуБыстройУстановкиЧасов(Команда)
	
	// Имя команды формируется по шаблону УстановитьЧасов_1_25 = установить 1.25 ч
	ЧастиИмени = СтрРазделить(Команда.Имя, "_");
	ЧастиИмени.Удалить(0);
	КоличествоЧасовСтрокой = СтрСоединить(ЧастиИмени, ".");
	
	Объект.Часов = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КоличествоЧасовСтрокой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораДеятельности()
	
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
	
	Элементы.ВидДеятельности.СписокВыбора.Очистить();
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Элементы.ВидДеятельности.СписокВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандыБыстройУстановкиЧасов()
	
	ШкалаТрудозатрат = СтрРазделить("0;0.25;0.5;1;1.5;2;3;4", ";", Ложь);
	
	Для Каждого КоличествоЧасов Из ШкалаТрудозатрат Цикл
		
		ИмяКоманды = "УстановитьЧасов_" + СтрЗаменить(КоличествоЧасов, ".", "_");
		
		// Добавляет команду на форму              
		ДобавленнаяКомандаФормы = Команды.Добавить(ИмяКоманды);      
		ДобавленнаяКомандаФормы.Действие = "Подключаемый_ВыполнитьКомандуБыстройУстановкиЧасов";
		ДобавленнаяКомандаФормы.Отображение = ОтображениеКнопки.Текст;
		ДобавленнаяКомандаФормы.ИзменяетСохраняемыеДанные=Истина;
		
		// Добавляет кнопку на форму, связывает ее с добавленной командной и помещает на командную панель формы
		ДобавленнаяКнопкаФормы = Элементы.Вставить(ИмяКоманды, Тип("КнопкаФормы"), Элементы.ГруппаТрудозатраты);
		ДобавленнаяКнопкаФормы.Заголовок = КоличествоЧасов;
		ДобавленнаяКнопкаФормы.ИмяКоманды = ИмяКоманды; 
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстКоммита()
	
	Если ТипЗнч(Объект.Предмет) = Тип("ДокументСсылка.Задача") Тогда
		ТекстКоммита = СтрШаблон("refs #%1 %2", 
						Формат(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Предмет,"Номер"), "ЧГ=0"),
						СтрЗаменить(Объект.Комментарий, Символы.ПС, " "));	
	Иначе
		ТекстКоммита = СтрЗаменить(Объект.Комментарий, Символы.ПС, " ");	
	КонецЕсли;
	
	// удалим из текста коммита периоды учета времени
	Компонента = РегулярныеВыраженияКлиентСервер.КомпонентаРегулярныхВыражений(Истина);
	ТекстКоммита = РегулярныеВыраженияКлиентСервер.Заменить(ТекстКоммита, "\[\d\d:\d\d\-\d\d:\d\d\]", "", Компонента);
	ТекстКоммита = СокрП(ТекстКоммита);
	
КонецПроцедуры

#КонецОбласти
