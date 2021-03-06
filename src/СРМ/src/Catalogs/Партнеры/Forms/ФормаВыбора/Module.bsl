#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОпределитьОтображениеСпискаПартнеров(Параметры.ТолькоСВнешнимДоступом);
	
	Справочники.Партнеры.УстановитьОформлениеСписка(Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьОтображениеСпискаПартнеров(ТолькоСВнешнимДоступом)
	
	ТекстВыбрать = "";
	ТекстИз = "";
	ТекстГде = "";
	
	// Проверка на подсистему
	Если ПравоДоступа("Чтение", Метаданные.Справочники.ВнешниеПользователи)
		И ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей") Тогда
		ТекстВыбрать = "ВЫРАЗИТЬ((ВЫРАЗИТЬ(НЕ ВнешниеПользователи.Ссылка ЕСТЬ NULL КАК БУЛЕВО)
		| И НЕ ВнешниеПользователи.Недействителен И НЕ ВнешниеПользователи.ПометкаУдаления) КАК БУЛЕВО) Как ВнешнийДоступ,";
		ТекстИз = " ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователи
		| ПО (СправочникПартнеры.Ссылка = ВнешниеПользователи.ОбъектАвторизации)";
		Элементы.ВнешнийДоступ.Видимость = Истина;
		
		Если ТолькоСВнешнимДоступом Тогда
			ТекстГде = " ГДЕ ВЫРАЗИТЬ(НЕ ВнешниеПользователи.Ссылка ЕСТЬ NULL КАК БУЛЕВО)
			| И НЕ ВнешниеПользователи.Недействителен И НЕ ВнешниеПользователи.ПометкаУдаления = ИСТИНА";
		КонецЕсли;
	КонецЕсли;
	
	Список.ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + ТекстВыбрать + "
	| СправочникПартнеры.Ссылка КАК Ссылка,
	| СправочникПартнеры.Код КАК Код,
	| СправочникПартнеры.Наименование КАК Наименование
	| ИЗ Справочник.Партнеры КАК СправочникПартнеры" + ТекстИз + ТекстГде;
	
КонецПроцедуры


#КонецОбласти



