

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)

	Если Статус=Перечисления.СтатусыОтчетовПоРаботамПартнеру.Формируется Тогда
		Возврат;
	КонецЕсли;
	
	// регистр ВысталенныеЗадачи 
	Движения.ВысталенныеЗадачи.Записывать = Истина;
	Для Каждого ТекСтрокаЗадачи Из Задачи Цикл
		Движение = Движения.ВысталенныеЗадачи.Добавить();
		Движение.Период = Дата;
//		Движение.ПериодРегистрации = ПериодРегистрации;
		Движение.Партнер = Партнер;
		Движение.Задача = ТекСтрокаЗадачи.Задача;
		Движение.Исполнитель = ТекСтрокаЗадачи.Исполнитель;
		Движение.КоличествоЧасов = ТекСтрокаЗадачи.КоличествоЧасов;
	КонецЦикла;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный=ПользователиКлиентСервер.ТекущийПользователь();
//	ПериодРегистрации=НачалоМесяца(ТекущаяДата());
	Статус=Перечисления.СтатусыОтчетовПоРаботамПартнеру.Формируется;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаЗадачи Из Задачи Цикл
		Если Не ЗначениеЗаполнено(СтрокаЗадачи.Ответственный) Тогда
			СтрокаЗадачи.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
			СтрокаЗадачи.ДатаВключенияВОтчет = ТекущаяДатаСеанса();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры


#КонецОбласти
