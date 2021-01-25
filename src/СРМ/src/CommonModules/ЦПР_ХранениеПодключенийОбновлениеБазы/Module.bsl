Процедура ПерейтиНаВерсию_0_0_0_1() Экспорт
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_0_0_0_2() Экспорт

	
	
	//1. Нужно сделать копию справочника точки подключений в справочник "подключения". И перевести все наши логины на новый справочник.
	Запрос=Новый ЗАпрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ЦПР_ТочкиПодключения.Ссылка КАК Ссылка,
	|	ЦПР_ТочкиПодключения.ВерсияДанных КАК ВерсияДанных,
	|	ЦПР_ТочкиПодключения.ПометкаУдаления КАК ПометкаУдаления,
	|	ЦПР_ТочкиПодключения.Родитель КАК Родитель,
	|	ЦПР_ТочкиПодключения.ЭтоГруппа КАК ЭтоГруппа,
	|	ЦПР_ТочкиПодключения.Код КАК Код,
	|	ЦПР_ТочкиПодключения.Наименование КАК Наименование,
	|	ЦПР_ТочкиПодключения.Партнер КАК Партнер,
	|	ЦПР_ТочкиПодключения.КонтактноеЛицо КАК КонтактноеЛицо,
	|	ЦПР_ТочкиПодключения.УдалитьВидПодключения КАК УдалитьВидПодключения,
	|	ЦПР_ТочкиПодключения.УдалитьАдрес КАК УдалитьАдрес,
	|	ЦПР_ТочкиПодключения.УдалитьПорт КАК УдалитьПорт,
	|	ЦПР_ТочкиПодключения.УдалитьПредварительноеПодключение КАК УдалитьПредварительноеПодключение,
	|	ЦПР_ТочкиПодключения.Комментарий КАК Комментарий,
	|	ЦПР_ТочкиПодключения.Предопределенный КАК Предопределенный,
	|	ЦПР_ТочкиПодключения.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	|ИЗ
	|	Справочник.ЦПР_ТочкиПодключения КАК ЦПР_ТочкиПодключения
	|ГДЕ
	|	НЕ ЦПР_ТочкиПодключения.ЭтоГруппа";
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовыйЭлемент=Справочники.ЦПР_Подключения.СоздатьЭлемент();
		НовыйЭлемент.Владелец=Выборка.Ссылка;
		//НовыйЭлемент.Наименование=Выборка.Наименование;
		НовыйЭлемент.Адрес=Выборка.УдалитьАдрес;
		НовыйЭлемент.Порт=Выборка.УдалитьПорт;
		НовыйЭлемент.ПредварительноеПодключение=Выборка.УдалитьПредварительноеПодключение;
		НовыйЭлемент.ВидПодключения=Выборка.УдалитьВидПодключения;
		НовыйЭлемент.Комментарий=Выборка.Комментарий;
		
		НовыйЭлемент.АдресПодключения=Справочники.ЦПР_Подключения.ПолучитьАдресПодключения(НовыйЭлемент.Адрес,НовыйЭлемент.Порт);
		НовыйЭлемент.ОбменДанными.Загрузка=Истина;
		Попытка
			НовыйЭлемент.Записать();
		Исключение
			ВызватьИсключение "Не удалось конвертировать справочник Тоек подключения в справочник Подключения "+ОписаниеОшибки();
		КонецПопытки;
		
		НаборСтарый=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.СоздатьНаборЗаписей();
		НаборСтарый.Отбор.ТочкаПодключения.Установить(Выборка.Ссылка,Истина);
		НаборСтарый.Прочитать();
		
		Для каждого Запись Из НаборСтарый Цикл 
			МенеджерЗАписи=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗАписи,Запись);
			МенеджерЗАписи.ТочкаПодключения=НовыйЭлемент.Ссылка;
			МенеджерЗАписи.Записать(Истина);
		КонецЦикла;
	КонецЦикла;
	
	//2. проставить в справочнике виды подключений тип подключния
	
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ЦПР_ВидыПодключений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЦПР_ВидыПодключений КАК ЦПР_ВидыПодключений
	|ГДЕ
	|	ЦПР_ВидыПодключений.ТипПодключения = &ТипПодключения";
	Запрос.УстановитьПараметр("ТипПодключения",Перечисления.ЦПР_ТипыПодключений.ПустаяСсылка());
	
	СоответствиеТиповПодключений=Новый Соответствие;
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.AmmyAdmin,Перечисления.ЦПР_ТипыПодключений.AmmyAdmin);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.HTTP,Перечисления.ЦПР_ТипыПодключений.HTTP);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.RDP,Перечисления.ЦПР_ТипыПодключений.RDP);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.TeamViewer,Перечисления.ЦПР_ТипыПодключений.TeamViewer);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.VNC,Перечисления.ЦПР_ТипыПодключений.VNC);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.VPN,Перечисления.ЦПР_ТипыПодключений.VPN);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.Роутер,Перечисления.ЦПР_ТипыПодключений.HTTP);
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Тип=СоответствиеТиповПодключений[Выборка.Ссылка];
		
		Если Не ЗначениеЗаполнено(Тип) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектВида=Выборка.Ссылка.ПолучитьОбъект();
		ОбъектВида.ТипПодключения=Тип;
		ОбъектВида.ИмяПредопределенныхДанных="";
		ОбъектВида.ОбменДанными.Загрузка=ИСтина;
		ОбъектВида.Записать();
	КонецЦикла;
КонецПроцедуры	
	
Процедура ПерейтиНаВерсию_0_0_0_3() Экспорт
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_0_0_0_4() Экспорт
	
	ОбновитьПредопределенныеВидыКонтактнойИнформации();
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_0_0_0_5() Экспорт
	
	//Вводим новые типы подключения в базу
	СоответствиеТиповПодключений=Новый Соответствие;
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.База1С,Перечисления.ЦПР_ТипыПодключений.База1С);
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.Хранилище1С,Перечисления.ЦПР_ТипыПодключений.Хранилище1С);
	
	Для Каждого КлючЗначение ИЗ СоответствиеТиповПодключений Цикл
		
		ОбъектВида=КлючЗначение.Ключ.ПолучитьОбъект();
		ОбъектВида.ТипПодключения=КлючЗначение.Значение;
		//ОбъектВида.ИмяПредопределенныхДанных="";
		ОбъектВида.ОбменДанными.Загрузка=ИСтина;
		ОбъектВида.Записать();
	КонецЦикла;
	
	//убираем Записи в учетных данных подключений без точки подключения
	
	Выборка=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.ТочкаПодключения) Тогда 
			Если ТипЗнч(Выборка.ТочкаПодключения)=Тип("СправочникСсылка.ЦПР_Подключения") Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Запись=Выборка.ПолучитьМенеджерЗаписи();
		
		Запись.Удалить();
	КонецЦикла;
	
	//Создаем элементы справочника Виды учетных данных
	
	МассивДанных=Новый Массив;
	МассивДанных.Добавить("Клиент");
	МассивДанных.Добавить("Разработчик");
	
	Для Каждого ТекЭлемент Из МассивДанных Цикл
		НовыйЭлемент=Справочники.ЦПР_ВидыУчетныхДанных.СоздатьЭлемент();
		НовыйЭлемент.Наименование=ТекЭлемент;
		НовыйЭлемент.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_0_0_0_6() Экспорт
	//Вводим новые типы подключения в базу
	СоответствиеТиповПодключений=Новый Соответствие;
	СоответствиеТиповПодключений.Вставить(Справочники.ЦПР_ВидыПодключений.UltraVNC,Перечисления.ЦПР_ТипыПодключений.UltraVNC);
	
	Для Каждого КлючЗначение ИЗ СоответствиеТиповПодключений Цикл
		
		ОбъектВида=КлючЗначение.Ключ.ПолучитьОбъект();
		ОбъектВида.ТипПодключения=КлючЗначение.Значение;
		//ОбъектВида.ИмяПредопределенныхДанных="";
		ОбъектВида.ОбменДанными.Загрузка=ИСтина;
		ОбъектВида.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_0_0_0_7() Экспорт
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_0_0_0() Экспорт
	//1. установить признаки подключений без логина
	МассивТиповПодключений=Новый Массив;
	МассивТиповПодключений.Добавить(Перечисления.ЦПР_ТипыПодключений.VNC);
	МассивТиповПодключений.Добавить(Перечисления.ЦПР_ТипыПодключений.UltraVNC);
	МассивТиповПодключений.Добавить(Перечисления.ЦПР_ТипыПодключений.TeamViewer);
	МассивТиповПодключений.Добавить(Перечисления.ЦПР_ТипыПодключений.AmmyAdmin);
	
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ЦПР_ВидыПодключений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЦПР_ВидыПодключений КАК ЦПР_ВидыПодключений
	|ГДЕ
	|	ЦПР_ВидыПодключений.ТипПодключения В(&ТипПодключения)";
	ЗАпрос.УстановитьПараметр("ТипПодключения",МассивТиповПодключений);
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект=Выборка.Ссылка.ПолучитьОбъект();
		Объект.БезЛогина=Истина;
		Объект.ОбменДанными.Загрузка=Истина;
		Объект.Записать();
	КонецЦикла;
	
	//Очистим логин по учетным данным без логина
	Запрос=Новый Запрос;
	ЗАпрос.Текст=
	"ВЫБРАТЬ
	|	ЦПР_УчетныеДанныеПодключений.ТочкаПодключения КАК ТочкаПодключения,
	|	ЦПР_УчетныеДанныеПодключений.Логин КАК Логин,
	|	ЦПР_УчетныеДанныеПодключений.Пароль КАК Пароль,
	|	ЦПР_УчетныеДанныеПодключений.Администратор КАК Администратор,
	|	ЦПР_УчетныеДанныеПодключений.Пользователь КАК Пользователь,
	|	ЦПР_УчетныеДанныеПодключений.Вид КАК Вид,
	|	ЦПР_УчетныеДанныеПодключений.Комментарий КАК Комментарий,
	|	ЦПР_УчетныеДанныеПодключений.ТребуетсяПроверкаПодключения КАК ТребуетсяПроверкаПодключения
	|ИЗ
	|	РегистрСведений.ЦПР_УчетныеДанныеПодключений КАК ЦПР_УчетныеДанныеПодключений
	|ГДЕ
	|	ЦПР_УчетныеДанныеПодключений.ТочкаПодключения.ВидПодключения.БезЛогина
	|	И ЦПР_УчетныеДанныеПодключений.Логин <> """"";
	
	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МенеджерЗаписи=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Выборка);
		
		МенеджерЗаписи.Удалить();
		
		МенеджерЗаписи=РегистрыСведений.ЦПР_УчетныеДанныеПодключений.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи,Выборка);
		МенеджерЗаписи.Логин="";
		МенеджерЗаписи.Записать(Истина);
	КонецЦИкла;
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_1_0_0() Экспорт
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_2_0_1() Экспорт
КонецПроцедуры

Процедура СоздатьВидПодключенияПоТипу(ТипПодключения,БезЛогина)
	Запрос=Новый Запрос;
	ЗАпрос.Текст=
	"ВЫБРАТЬ
	|	ЦПР_ВидыПодключений.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЦПР_ВидыПодключений КАК ЦПР_ВидыПодключений
	|ГДЕ
	|	ЦПР_ВидыПодключений.ТипПодключения = &ТипПодключения";
	Запрос.УстановитьПараметр("ТипПодключения",ТипПодключения);
	Выборка=ЗАпрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	НовыйЭлемент=Справочники.ЦПР_ВидыПодключений.СоздатьЭлемент();
	НовыйЭлемент.Наименование=Строка(ТипПодключения);
	НовыйЭлемент.ТипПодключения=ТипПодключения;
	НовыйЭлемент.БезЛогина=БезЛогина;
	НовыйЭлемент.УстановитьНовыйКод();
	НовыйЭлемент.Записать();
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_2_1_1() Экспорт
	//создадим вид подключения
	СоздатьВидПодключенияПоТипу(Перечисления.ЦПР_ТипыПодключений.AnyDesk,Истина);
	СоздатьВидПодключенияПоТипу(Перечисления.ЦПР_ТипыПодключений.ИТС,Ложь);
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_3_0_4() Экспорт
	
	Константы.RA_ДатаПоследнейЗагрузкиИзRedmine.Установить(ТекущаяДата());
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_3_1_0() Экспорт
	
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_3_1_2() Экспорт
	
	УстановитьВидСтатусаНовый();
	УстановитьСтатусНовыйДляСуществующихЗадач();
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_3_1_3() Экспорт
	
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_3_1_5() Экспорт
	
	
КонецПроцедуры

Процедура ПерейтиНаВерсию_1_4_0_1() Экспорт
	//Обновление на новую БСП	
КонецПроцедуры	
	
Процедура ПерейтиНаВерсию_1_5_0_1() Экспорт
	ЗаполнитьНовыеВидыКИ();
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформациюДляСписков();
КонецПроцедуры	

Процедура ПерейтиНаВерсию_1_6_0_1() Экспорт
	Справочники.СпискиСтатусовЗадач.ЗаполнитьПоУмолчанию();
КонецПроцедуры	

Процедура ПерейтиНаВерсию_1_6_1_3() Экспорт
	Обучение.ЗаполнитьСправочникУроковПоПланамОбучения();
	Обучение.ЗаполнитьУрокиВПланахОбучения();
КонецПроцедуры	

Процедура ПерейтиНаВерсию_1_6_1_6() Экспорт
	УправлениеЗадачамиСлужебный.ЗаполнитьАвтораВРегистреТрудозатраты();	
КонецПроцедуры	

Процедура ПерейтиНаВерсию_1_6_3_1() Экспорт
	
	//Справочник "Организации"
		ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ЮридическийАдресОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ФактическийАдресОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Адрес");
	ПараметрыВида.Вид = "ПочтовыйАдресОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 3;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Телефон");
	ПараметрыВида.Вид = "ТелефонОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 4;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("АдресЭлектроннойПочты");
	ПараметрыВида.Вид = "EmailОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 5;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Факс");
	ПараметрыВида.Вид = "ФаксОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 6;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации("Другое");
	ПараметрыВида.Вид = "ДругаяИнформацияОрганизации";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 7;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид                               = "МеждународныйАдресОрганизации";
	ПараметрыВида.Порядок                           = 4;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РедактированиеТолькоВДиалоге      = Ложь;
	ПараметрыВида.ОбязательноеЗаполнение            = Ложь;
	ПараметрыВида.МеждународныйФорматАдреса         = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "Контрагенты"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид = "АдресКонтрагента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	ПараметрыВида.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ПараметрыВида.Вид = "EmailКонтрагента";
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Skype);
	ПараметрыВида.Вид = "SkypeКонтрагенты";
	ПараметрыВида.Порядок = 3;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Ложь;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
КонецПроцедуры	

Процедура ЗаполнитьНовыеВидыКИ()
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонКонтактногоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонФизическогоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений=Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Skype);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.SkypeФизическогоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений=Истина;
	ПараметрыВида.Порядок = 3;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.ВебСтраница);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ВебСтраницаФизическогоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений=Истина;
	ПараметрыВида.Порядок = 4;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресФизическогоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	//ПараметрыВида.РазрешитьВводНесколькихЗначений=Истина;
	ПараметрыВида.Порядок = 7;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Другое);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияФизическогоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	//ПараметрыВида.РазрешитьВводНесколькихЗначений=Истина;
	ПараметрыВида.Порядок = 7;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры

// Обновляет значения реквизитов предопределенных видов контактной информации.
Процедура ОбновитьПредопределенныеВидыКонтактнойИнформации() 
	
	// группы
	Объект = Справочники.ВидыКонтактнойИнформации.СправочникПартнеры.ПолучитьОбъект();
	Объект.Используется = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	
	Объект = Справочники.ВидыКонтактнойИнформации.СправочникКонтактныеЛицаПартнеров.ПолучитьОбъект();
	Объект.Используется = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	
	Объект = Справочники.ВидыКонтактнойИнформации.СправочникФизическиеЛица.ПолучитьОбъект();
	Объект.Используется = Истина;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	
	// Справочник "Партнеры"
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресПартнера;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Телефон);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.ТелефонПартнера;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailПартнера;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 3;
	ПараметрыВида.НастройкиПроверки.ПроверятьКорректность = Истина;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "Физические лица".
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EMailФизическиеЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	// Справочник "Контактные лица партнеров".
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.АдресКонтактногоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.Порядок = 1;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
	ПараметрыВида = УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	ПараметрыВида.Вид = Справочники.ВидыКонтактнойИнформации.EmailКонтактногоЛица;
	ПараметрыВида.МожноИзменятьСпособРедактирования = Истина;
	ПараметрыВида.РазрешитьВводНесколькихЗначений = Истина;
	ПараметрыВида.Порядок = 2;
	УправлениеКонтактнойИнформацией.УстановитьСвойстваВидаКонтактнойИнформации(ПараметрыВида);
	
КонецПроцедуры



#Область УстановкаСтатусаНовыйДляСуществующихЗадач

Процедура УстановитьВидСтатусаНовый()
	
	Статус = Справочники.RA_RedmineСтатусы.НайтиПоКоду("1");
	Если ЗначениеЗаполнено(Статус) Тогда
		СтатусОбъект = Статус.ПолучитьОбъект();
		СтатусОбъект.ВидСтатуса = Перечисления.RA_RedmineВидыСтатусовЗадач.Новая;
		СтатусОбъект.Записать();
	Иначе
		ВызватьИсключение "Не найден статус с кодом 1 (Новый)";
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСтатусНовыйДляСуществующихЗадач()
	
	Задача = Справочники.RA_RedmineЗадачи.Выбрать();
	
	Пока Задача.Следующий() Цикл
		
		Запись = РегистрыСведений.RA_RedmineИсторияСтатусовЗадач.СоздатьМенеджерЗаписи();
		Запись.Период = Задача.ДатаСоздания;
		Запись.Задача = Задача.Ссылка;
		Запись.Статус = RA_RedmineПротоколПодключенияПовтИсп.СтатусЗадачиНовый();
		Запись.Пользователь = Задача.Автор;
		Запись.Комментарий = "Установлен автоматически при создании задачи";
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
