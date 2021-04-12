&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборыПоАрхивностиПроекта(Проекты, ПоказыватьАрхивныеПроекты)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Проекты, "Архивный", Ложь, ВидСравненияКомпоновкиДанных.Равно, , Не ПоказыватьАрхивныеПроекты,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьАрхивныеПроектыПриИзменении(Элемент)
	УстановитьОтборыПоАрхивностиПроекта(Список, ПоказыватьАрхивныеПроекты);
КонецПроцедуры


&НаКлиенте
Процедура ТолькоМоиПроектыПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ЭтоИзбранныйПроект", Истина, ВидСравненияКомпоновкиДанных.Равно, , ТолькоМоиПроекты,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	Если ТолькоМоиПроекты Тогда
		Элементы.Список.Отображение=ОтображениеТаблицы.Список;
	Иначе
		Элементы.Список.Отображение=ОтображениеТаблицы.Дерево;
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Справочники.Проекты.УстановитьОформлениеСписка(Список);
	
	УстановитьОтборыПоАрхивностиПроекта(Список, ПоказыватьАрхивныеПроекты);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", Пользователи.ТекущийПользователь());
КонецПроцедуры
