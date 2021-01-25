
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;

	УстановитьПараметрыДинамическогоСпискаТрудозатрат();
	УстановитьПараметрыДинамическогоСпискаИсторииИзменений();
	
	ОбновитьКомментарии();
	
	ОбновитьВсегоТрудозатрат();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВсегоТрудозатрат()
	
	ВсегоТрудозатрат = RA_RedmineСервер.ВсегоТрудозатратПоЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаТрудозатрат()
	
	Трудозатраты.Параметры.УстановитьЗначениеПараметра("Задача", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыДинамическогоСпискаИсторииИзменений()
	
	ИсторияИзменений.Параметры.УстановитьЗначениеПараметра("Владелец", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомментарии()
	
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	RA_RedmineИзмененияЗадач.ДатаСоздания КАК ДатаСоздания,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(RA_RedmineИзмененияЗадач.Пользователь) КАК Пользователь,
	|	RA_RedmineИзмененияЗадач.Комментарий КАК Комментарий
	|ИЗ
	|	Справочник.RA_RedmineИзмененияЗадач КАК RA_RedmineИзмененияЗадач
	|ГДЕ
	|	RA_RedmineИзмененияЗадач.Владелец = &Владелец
	|	И RA_RedmineИзмененияЗадач.ВидИзменения = &ВидИзменения
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаСоздания";
	Запрос.УстановитьПараметр("Владелец", Объект.Ссылка);
	Запрос.УстановитьПараметр("ВидИзменения", Перечисления.RA_RedmineВидыИзмененийЗадач.Комментарий);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивКомментариев = Новый Массив;
	ШаблонКомментария = "<P><EM>%1 %2:</EM></P><P>%3<HR /></P>";
	
	// первый комментарий - описание задачи
	СтрокаКомментария = СтрШаблон(ШаблонКомментария, Объект.ДатаСоздания, Объект.Автор, ?(ЗначениеЗаполнено(Объект.Описание), Объект.Описание, Объект.Наименование));
		
	МассивКомментариев.Добавить(СтрокаКомментария);
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаКомментария = СтрШаблон(ШаблонКомментария, Выборка.ДатаСоздания, Выборка.Пользователь, Выборка.Комментарий);
			
		МассивКомментариев.Добавить(СтрокаКомментария);
		
	КонецЦикла;
	
	Комментарии = "<HTML><HEAD><META content=""text/html; charset=utf-8""></HEAD><BODY>"
		+ СтрСоединить(МассивКомментариев,"") + "</BODY></HTML>";
	
КонецПроцедуры
