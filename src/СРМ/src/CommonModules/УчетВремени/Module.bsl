////////////////////////////////////////////////////////////////////////////////
// УчетВремени
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Функция ДоступныеВидыДеятельностиУчетаТрудозатрат() Экспорт
	Запрос=Новый Запрос;
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ВидыДеятельности.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыДеятельности КАК ВидыДеятельности
	|ГДЕ
	|	НЕ ВидыДеятельности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВидыДеятельности.РеквизитДопУпорядочивания";

	Виды=Новый Массив;

	Выборка=Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Виды.Добавить(Выборка.Ссылка);
	КонецЦикла;

	Возврат Виды;
КонецФункции

Процедура ЗафиксироватьТрудозатраты(Предмет, Часов, ВидДеятельности, Комментарий) Экспорт
	НовыйДокументТрудозатрат=Документы.Трудозатраты.СоздатьДокумент();
	НовыйДокументТрудозатрат.Автор=Пользователи.текущийПользователь();
	НовыйДокументТрудозатрат.ВидДеятельности=ВидДеятельности;
	НовыйДокументТрудозатрат.Предмет=Предмет;
	НовыйДокументТрудозатрат.Дата=ТекущаяДатаСеанса();
	НовыйДокументТрудозатрат.Комментарий=Комментарий;
	НовыйДокументТрудозатрат.Часов=Часов;
	НовыйДокументТрудозатрат.УстановитьНовыйНомер();
	НовыйДокументТрудозатрат.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры

Процедура ДобавитьКомандыБыстройУстановкиЧасов(Форма, ГруппаТрудозатраты) Экспорт

	ШкалаТрудозатрат = УчетВремениКлиентСервер.ШкалаЗначенийТрудозатрат();

	Для Каждого КоличествоЧасов Из ШкалаТрудозатрат Цикл

		ИмяКоманды = "УчетВремени_УстановитьЧасов_" + СтрЗаменить(КоличествоЧасов, ".", "_");
		
		// Добавляет команду на форму              
		ДобавленнаяКомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
		ДобавленнаяКомандаФормы.Действие = "Подключаемый_УчетВремени_ВыполнитьКомандуБыстройУстановкиЧасов";
		ДобавленнаяКомандаФормы.Отображение = ОтображениеКнопки.Текст;
		ДобавленнаяКомандаФормы.ИзменяетСохраняемыеДанные=Истина;
		
		// Добавляет кнопку на форму, связывает ее с добавленной командной и помещает на командную панель формы
		ДобавленнаяКнопкаФормы = Форма.Элементы.Вставить(ИмяКоманды, Тип("КнопкаФормы"), ГруппаТрудозатраты);
		ДобавленнаяКнопкаФормы.Заголовок = КоличествоЧасов;
		ДобавленнаяКнопкаФормы.ИмяКоманды = ИмяКоманды;

	КонецЦикла;

КонецПроцедуры


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти