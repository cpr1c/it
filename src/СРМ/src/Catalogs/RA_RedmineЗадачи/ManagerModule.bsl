
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	//Представление="Задача #"+Формат(Данные.Номер,"ЧГ=0")+": "+Данные.Статус+": "+Данные.Тема;
	Представление = СтрШаблон("#%1: %2 (%3)", 
		Формат(Данные.Код,"ЧГ=0"),
		Данные.Наименование,
		Данные.Статус);
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	СтандартнаяОбработка=Ложь;
	
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	Поля.Добавить("Статус");
КонецПроцедуры
