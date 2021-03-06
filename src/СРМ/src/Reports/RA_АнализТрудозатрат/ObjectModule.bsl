#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт

КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора.
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровкиОбъект, СтандартнаяОбработка, АдресХранилища)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	Период = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Период").Значение;
	ВариантОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВариантОтчета").Значение;
	
	Если ВариантОтчета <> "ДиаграммаГанта" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ВариантОтчета = "ДиаграммаГанта" Тогда
		ПродолжительностьРаботыПользователей(НастройкиОтчета, ДокументРезультат, КомпоновщикНастроек);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	Период = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Период").Значение;
	ВариантОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВариантОтчета").Значение;
	
	Если ВариантОтчета = "ДиаграммаГанта" 
		И Период.ДатаОкончания - Период.ДатаНачала > 31*24*60*60 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите период меньше 1 месяца");
		Отказ = Истина;
		
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПродолжительностьРаботыПользователей(НастройкиОтчета, ДокументРезультат, КомпоновщикНастроек)
	
	ВыводитьЗаголовок = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ВыводитьЗаголовок");
	ВыводитьОтбор = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
	ЗаголовокОтчета = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("Заголовок");
	Период = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Период").Значение;
	
	Если Не ЗначениеЗаполнено(Период.ДатаНачала) Тогда
		ДатаНачала = НачалоДня(ТекущаяДата());
	Иначе
		ДатаНачала = Период.ДатаНачала;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Период.ДатаОкончания) Тогда
		ДатаОкончания = КонецДня(ТекущаяДата());
	Иначе
		ДатаОкончания = Период.ДатаОкончания;
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ДатаНачала", ДатаНачала);
	ПараметрыЗаполнения.Вставить("ДатаОкончания", ДатаОкончания);
	ПараметрыЗаполнения.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	ПараметрыЗаполнения.Вставить("ВыводитьОтбор", ВыводитьОтбор);
	ПараметрыЗаполнения.Вставить("ЗаголовокОтчета", ЗаголовокОтчета);
	
	РезультатФормированияОтчета =
		Отчеты.RA_АнализТрудозатрат.СформироватьОтчетПоПродолжительностиРаботыПользователей(ПараметрыЗаполнения);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", РезультатФормированияОтчета.ОтчетПустой);
	ДокументРезультат.Вывести(РезультатФормированияОтчета.Отчет);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли