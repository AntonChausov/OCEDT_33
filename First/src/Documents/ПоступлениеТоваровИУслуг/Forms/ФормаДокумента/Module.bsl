
&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	РасчетСтрокиПоляСуммы();

КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	РасчетСтрокиПоляСуммы();
		
КонецПроцедуры


&НаКлиенте
Процедура РасчетСтрокиПоляСуммы()
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		 Возврат;
	Иначе ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Цена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоСумме(Команда)
	
	Если Объект.СортироватьПоВозрастанию = Ложь Тогда
		 Объект.Товары.Сортировать("Сумма Убыв");
		 Объект.СортироватьПоВозрастанию = Истина;
		 
		 	КартинкаСортировки = БиблиотекаКартинок.ОформлениеСтрелкаВверхЗеленая;
		 	Элементы.ТоварыСортироватьПоСумме.Картинка = КартинкаСортировки;
			
			УстановитьПодсказкуСортироватьПоСуммеПоВозр("СортироватьПоСумме");
			Элементы.ТоварыСортироватьПоСумме.Заголовок = "Сортировать по возрастанию";
	 Иначе
		 Объект.Товары.Сортировать("Сумма Возр");
		 Объект.СортироватьПоВозрастанию = Ложь;
		 
		 	КартинкаСортировки = БиблиотекаКартинок.ОформлениеСтрелкаВнизКрасная;
		 	Элементы.ТоварыСортироватьПоСумме.Картинка = КартинкаСортировки;
			
			УстановитьПодсказкуСортироватьПоСуммеПоУбыв("СортироватьПоСумме");
			Элементы.ТоварыСортироватьПоСумме.Заголовок = "Сортировать по убыванию";
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуСортироватьПоСуммеПоУбыв(ИмяКоманды)
	Команды.Найти(ИмяКоманды).Подсказка = "Сортировать по сумме по убыванию";
КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуСортироватьПоСуммеПоВозр(ИмяКоманды)
	Команды.Найти(ИмяКоманды).Подсказка = "Сортировать по сумме по возрастанию";
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.Цена = 0 Тогда
		 Возврат;
	 Иначе ЦелаяЧастьКоличества = Цел(ТекущиеДанные.Сумма / ТекущиеДанные.Цена);
		   ТекущиеДанные.Количество = ЦелаяЧастьКоличества;
		   НоваяСумма = ЦелаяЧастьКоличества * ТекущиеДанные.Цена;
		   ТекущиеДанные.Сумма = НоваяСумма;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)     
	
	ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаВыбораСписком", , Элементы.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВыбранныеДанные Из ВыбранноеЗначение Цикл
		
		СтрокаТаблицы = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ВыбранныеДанные);
		
	КонецЦикла;
	
	ПослеПодбора();
	
КонецПроцедуры 


&НаСервере
Процедура ПослеПодбора() Экспорт

	Таблица = Новый ТаблицаЗначений;
    Таблица = Объект.Товары.Выгрузить();    
    Таблица.Свернуть("Номенклатура","Количество, Цена, Сумма");
	// Пересчитываем Сумму в строках перед выгрузкой в Табличную часть
	Для Каждого СтрокаТЗ Из Таблица Цикл
		СтрокаТЗ.Сумма = СтрокаТЗ.Количество * СтрокаТЗ.Цена;
	КонецЦикла;
	// Выгружаем
	Объект.Товары.Загрузить(Таблица);
	
КонецПроцедуры



