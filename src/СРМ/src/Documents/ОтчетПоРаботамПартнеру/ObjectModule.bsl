

#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ВысталенныеЗадачи 
	Движения.ВысталенныеЗадачи.Записывать = Истина;
	Для Каждого ТекСтрокаЗадачи Из Задачи Цикл
		КоличествоЧасовПоДополнительнымИсполнителям = 0;
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("КлючСтроки",ТекСтрокаЗадачи.КлючСтроки);
		
		СтрокиДопИсполнителей = ДополнительныеИсполнители.НайтиСтроки(СтруктураПоиска);
		Для Каждого СтрокаДопИсполнителя Из СтрокиДопИсполнителей Цикл
			КоличествоЧасовПоДополнительнымИсполнителям = КоличествоЧасовПоДополнительнымИсполнителям
														  + СтрокаДопИсполнителя.КоличествоЧасов;
			Движение = Движения.ВысталенныеЗадачи.Добавить();
			Движение.Период = КонецМесяца(ПериодРегистрации);
			Движение.Партнер = Партнер;
			Движение.ВидОплаты = ТекСтрокаЗадачи.ВидОплаты;
			Движение.Задача = ТекСтрокаЗадачи.Задача;
			Движение.Исполнитель = СтрокаДопИсполнителя.Исполнитель;
			Движение.КоличествоЧасов = СтрокаДопИсполнителя.КоличествоЧасов;
		КонецЦикла;

		Если КоличествоЧасовПоДополнительнымИсполнителям > ТекСтрокаЗадачи.КоличествоЧасов Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Количество часов по дополнительным исполнителям не может превышать общего количества часов по задаче",
															  Ссылка,
															  "Объект.Задачи["
															  + (ТекСтрокаЗадачи.НомерСтроки - 1)
															  + "].КоличествоЧасов",
															  ,
															  Отказ);
		КонецЕсли;

		ЧасовПоОсновномуИсполнителю = ТекСтрокаЗадачи.КоличествоЧасов - КоличествоЧасовПоДополнительнымИсполнителям;

		Если ЗначениеЗаполнено(ЧасовПоОсновномуИсполнителю) Тогда
			Движение = Движения.ВысталенныеЗадачи.Добавить();
			Движение.Период = КонецМесяца(ПериодРегистрации);
			Движение.Партнер = Партнер;
			Движение.ВидОплаты = ТекСтрокаЗадачи.ВидОплаты;
			Движение.Задача = ТекСтрокаЗадачи.Задача;
			Движение.Исполнитель = ТекСтрокаЗадачи.Исполнитель;
			Движение.КоличествоЧасов = ЧасовПоОсновномуИсполнителю;
		КонецЕсли;
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
