
Функция РядФибоначчи() Экспорт
	
	Ряд = Новый Массив;
	Ряд.Добавить(1);
	Ряд.Добавить(2);
	Для н = 1 По 99 Цикл
		Ряд.Добавить(Ряд[н] + Ряд[н-1]);
	КонецЦикла;
	
	Возврат Ряд;
	
КонецФункции

Функция ОценкаПоРядуФибоначчи(ТекущееЗначение) Экспорт
	
	Если ТипЗнч(ТекущееЗначение) <> Тип("Число")
		ИЛИ ТекущееЗначение <= 1 Тогда
		
		Возврат 1;
	КонецЕсли;
	
	Ряд = РядФибоначчи();
	
	// просто пойдем по порядку
	Для инд = 0 По Ряд.ВГраница() Цикл
		ЗначениеПоРяду = Ряд[инд];
		Если ТекущееЗначение < ЗначениеПоРяду Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// определим, к какому значению ближе текущее
	РазницаНазад = ТекущееЗначение - Ряд[инд-1];
	РазницаВперед = Ряд[инд] - ТекущееЗначение;
	
	Если РазницаВперед > РазницаНазад Тогда
		Возврат Ряд[инд-1];
	Иначе
		Возврат Ряд[инд];
	КонецЕсли;
	
КонецФункции

Процедура ОбновитьНадписьКоличестваДополнительныхПолучателейСообщений(Событие,ЭлементНадписи) Экспорт 
	Если Событие.ПолучателиКопий.Количество()=0 Тогда
		ЭлементНадписи.Заголовок="Добавить получателей писем";
	Иначе
		ЭлементНадписи.Заголовок="Копии ("+Событие.ПолучателиКопий.Количество()+")";
	КонецЕсли;
КонецПроцедуры