
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Код процедур и функций


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОценкаТрудозатрат = Параметры.ОценкаТрудозатрат;	
	
	Для Каждого Стр Из Параметры.ДополнительныеИсполнители Цикл
		НоваяСтрока = ДополнительныеИсполнители.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Стр);
	КонецЦикла;
КонецПроцедуры


&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Добавить("ДополнительныеИсполнители.Исполнитель");
	ПроверяемыеРеквизиты.Добавить("ДополнительныеИсполнители.ОценкаТрудозатрат");
	
	Если ОценкаТрудозатрат < ДополнительныеИсполнители.Итог("ОценкаТрудозатрат") Тогда
		ОбщегоНазначения.СообщитьПользователю("Оценка трудозатрат по дополнительным исполнителям не может превышать общую оценку трудозатрат по задаче",
											  ,
											  ,
											  ,
											  Отказ);
	КонецЕсли;

КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы //<ИмяТаблицыФормы>

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	МассивИсполнителей = Новый Массив;
	Для Каждого Стр Из ДополнительныеИсполнители Цикл
		ДопИсполнитель = Новый Структура;
		ДопИсполнитель.Вставить("Исполнитель", Стр.Исполнитель);
		ДопИсполнитель.Вставить("ОценкаТрудозатрат", Стр.ОценкаТрудозатрат);
		
		МассивИсполнителей.Добавить(ДопИсполнитель);
	КонецЦикла;
	
	Закрыть(МассивИсполнителей);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти
