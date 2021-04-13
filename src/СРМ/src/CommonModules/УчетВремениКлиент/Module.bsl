
////////////////////////////////////////////////////////////////////////////////
// УчетВремениКлиент
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы() Экспорт

	ОбновитьПараметрВедетсяУчетВремени();

КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт

	Если ПараметрыПриложения["ВедетсяУчетВремени"] = Истина Тогда

		Отказ = Истина;

		НовоеПредупреждение = СтандартныеПодсистемыКлиент.ПредупреждениеПриЗавершенииРаботы();
		НовоеПредупреждение.ТекстПредупреждения = "ЗАВЕРШИТЕ УЧЕТ ВРЕМЕНИ ПЕРЕД ЗАВЕРШЕНИЕМ РАБОТЫ!";
		НовоеПредупреждение.ТекстГиперссылки = "Открыть форму управления таймерами";
		НовоеПредупреждение.ДействиеПриНажатииГиперссылки.Форма = "Обработка.УправлениеТаймерамиУчетаВремени.Форма.Форма";
		НовоеПредупреждение.ДействиеПриНажатииГиперссылки.ПрикладнаяФормаПредупреждения = "Обработка.УправлениеТаймерамиУчетаВремени.Форма.Форма";

		Предупреждения.Добавить(НовоеПредупреждение);

	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьПараметрВедетсяУчетВремени() Экспорт

	ПараметрыПриложения.Вставить("ВедетсяУчетВремени", УчетВремениВызовСервера.ВедетсяУчетВремени());

КонецПроцедуры

Процедура ОткрытьПредметТаймера(Ид) Экспорт

	ДанныеТаймера=УчетВремениВызовСервера.ДанныеТаймера(Ид);
	Если ЗначениеЗаполнено(ДанныеТаймера.Предмет) Тогда
		ПоказатьЗначение( , ДанныеТаймера.Предмет);
	КонецЕсли;

КонецПроцедуры

Процедура РеквизитТаймераПриИзменении(Форма, Элемент) Экспорт

	ИмяЭлемента = Элемент.Имя;

	МассивИменаЭлемента=СтрРазделить(ИмяЭлемента, "_");
	МассивИменаЭлемента.Удалить(0);//Префикс

	ИмяРеквизита = МассивИменаЭлемента[0];
	МассивИменаЭлемента.Удалить(0);
	Идентификатор = СтрСоединить(МассивИменаЭлемента, "-");
	ЗначениеРеквизита = Форма[Элемент.Имя];

	ПараметрыУчетаВремени = Новый Структура(ИмяРеквизита, ЗначениеРеквизита);
	УчетВремениВызовСервера.ОтразитьИзменениеТаймераУчетаВремени(Идентификатор, ПараметрыУчетаВремени);

КонецПроцедуры

Процедура ОбработатьКомандуУчетаВремени(Форма, Команда) Экспорт

	ИмяКоманды = Команда.Имя;

	МассивИмениКоманды=СтрРазделить(ИмяКоманды, "_");

	Действие = МассивИмениКоманды[1];
	МассивИмениКоманды.Удалить(0);
	МассивИмениКоманды.Удалить(0);

	Ид = СтрСоединить(МассивИмениКоманды, "-");

//	Комментарий = "";
	ДанныеТаймераФормы=УчетВремениКлиентСервер.ДанныеТаймераФормы(Форма, Ид);
	ДополнительныеПараметры = Новый Структура("Действие, Ид, Комментарий, Форма", Действие, Ид, ДанныеТаймераФормы.Комментарий, Форма);
	Оповещение = Новый ОписаниеОповещения("ОбработатьКомандуУчетаВремениПослеДиалога", ЭтотОбъект,
		ДополнительныеПараметры);

	Если Действие = "Отмена" Тогда
		ПоказатьВопрос(Оповещение, "Удалить выбранный таймер безвозвратно?", РежимДиалогаВопрос.ДаНет);
	ИначеЕсли Действие = "ОткрытьПредмет" Тогда
		ОткрытьПредметТаймера(Ид);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение, Истина);
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьОтображениеВремениТаймеров(Форма, ГруппаТаймеров) Экспорт
	ПрефиксЭлементов=УчетВремениКлиентСервер.ПрефиксЭлементовФормы();
	Для Каждого Элемент Из ГруппаТаймеров.ПодчиненныеЭлементы Цикл
		ИдентификаторТаймера=УчетВремениКлиентСервер.ИдентификаторТаймераПоИмениГруппыТаймера(Элемент.Имя);
		Ид=СтрЗаменить(ИдентификаторТаймера, "-", "_");
		
		ДанныеТаймераФормы=УчетВремениКлиентСервер.ДанныеТаймераФормы(Форма, ИдентификаторТаймера);
		
		ЭлементКомментария=Форма.Элементы.Найти(ПрефиксЭлементов + "Комментарий_" + Ид);	
		Если ЗначениеЗаполнено(ЭлементКомментария.ТекстРедактирования) 
			И ЭлементКомментария.ТекстРедактирования<>Форма[ПрефиксЭлементов + "Комментарий_" + Ид] Тогда
//			ДанныеТаймераФормы.Комментарий=ЭлементКомментария.ТекстРедактирования;
//			Форма[ПрефиксЭлементов + "Комментарий_" + Ид]=ДанныеТаймераФормы.Комментарий;
//			
//			
//			ПараметрыУчетаВремени = Новый Структура("Комментарий", ДанныеТаймераФормы.Комментарий);
//			УчетВремениВызовСервера.ОтразитьИзменениеТаймераУчетаВремени(ИдентификаторТаймера, ПараметрыУчетаВремени);

			Продолжить;			
		КонецЕсли;
			
		УчетВремениКлиентСервер.ОбновитьОтображениеВремениТаймера(Форма, ДанныеТаймераФормы, Ид);
			
	КонецЦикла;
КонецПроцедуры

Процедура ПодключитьОбработчикОжиданияОбновлениеОтображенияВремени(Форма) Экспорт
	Форма.ПодключитьОбработчикОжидания("Подключаемый_УчетВремени_ОбновитьПродолжительностьАвтоматически", 60);
КонецПроцедуры

Процедура СоздатьИСтартоватьТаймерПоПредмету(Предмет) Экспорт
	УчетВремениВызовСервера.СоздатьИСтартоватьТаймер(Предмет);
	Оповестить("ИзмененТаймер");

КонецПроцедуры

Процедура ОбработкаОповещенияФормы(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	Если Не Форма.Открыта() Тогда
		Возврат;
	КонецЕсли;

	Если ИмяСобытия = "ЗафиксированыТрудозатратыПоТаймеру" Тогда
		УчетВремениВызовСервера.УдалитьТаймер(Параметр);
		Форма.Подключаемый_УчетВремени_ОбновитьЭлементыТаймеров();
	ИначеЕсли ИмяСобытия = "ИзмененТаймер" Тогда
		Форма.Подключаемый_УчетВремени_ОбновитьЭлементыТаймеров();
	КонецЕсли;
КонецПроцедуры

Процедура ВыполнитьКомандуБыстройУстановкиЧасов(Форма, Команда, ПутьКДанным) Экспорт
	// Имя команды формируется по шаблону УстановитьЧасов_1_25 = установить 1.25 ч
	ЧастиИмени = СтрРазделить(Команда.Имя, "_");
	ЧастиИмени.Удалить(0);
	ЧастиИмени.Удалить(0);
	КоличествоЧасовСтрокой = СтрСоединить(ЧастиИмени, ".");
	Часов=СтроковыеФункцииКлиентСервер.СтрокаВЧисло(КоличествоЧасовСтрокой);

	ЧастиПутьКДанным=СтрРазделить(ПутьКДанным, ".");

	Если ЧастиПутьКДанным.Количество() = 1 Тогда
		Форма[ПутьКДанным]=Часов;
	ИначеЕсли ЧастиПутьКДанным.Количество() = 2 Тогда
		Форма[ЧастиПутьКДанным[0]][ЧастиПутьКДанным[1]]=Часов;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработатьКомандуУчетаВремениПослеДиалога(РезультатДиалога, ДополнительныеПараметры) Экспорт

	Если РезультатДиалога = Неопределено Или РезультатДиалога = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	ТекДата = ТекущаяДата();

	Идентификатор = ДополнительныеПараметры.Ид;
	Действие = ДополнительныеПараметры.Действие;

	Если Действие = "Старт" Тогда
		УчетВремениВызовСервера.СтартоватьТаймер(Идентификатор);
	ИначеЕсли Действие = "Отмена" Тогда
		УчетВремениВызовСервера.УдалитьТаймер(Идентификатор);
	ИначеЕсли Действие = "Стоп" Тогда
		УчетВремениВызовСервера.ОстановитьТаймер(Идентификатор);
	ИначеЕсли Действие = "Зафиксировать" Тогда
		УчетВремениВызовСервера.ОстановитьТаймер(Идентификатор);

		ДанныеТаймера=УчетВремениВызовСервера.ДанныеТаймера(Идентификатор);
		ЗначенияЗаполнения  = Новый Структура("Предмет,Часов,Комментарий,ВидДеятельности");
		ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, ДанныеТаймера);
		ПараметрыФормы = Новый Структура("ЗначенияЗаполнения,Идентификатор", ЗначенияЗаполнения, Идентификатор);
		ОткрытьФорму("Документ.Трудозатраты.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);

	КонецЕсли;

	Оповестить("ИзмененТаймер");

//	УстановитьВидимостьКомандУчетаВремени(ЭтотОбъект, ДанныеТаймера, Ид);
//
//	ТекДата = ТекущаяДата();
//	ОбновитьОтображениеВремениТаймера(ЭтотОбъект, ДанныеТаймера, Ид, ТекДата);
//
//	Если Действие = "Отмена" И РезультатДиалога = КодВозвратаДиалога.Да Тогда
//		Если УчетВремениВызовСервера.УдалитьТаймер(Идентификатор) Тогда
//			Объект.Таймеры.Удалить(ДанныеТаймера);
//			УдалитьЭлементыТаймера(Ид);
//		КонецЕсли;
//	КонецЕсли;

	УчетВремениКлиент.ОбновитьПараметрВедетсяУчетВремени();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
#КонецОбласти