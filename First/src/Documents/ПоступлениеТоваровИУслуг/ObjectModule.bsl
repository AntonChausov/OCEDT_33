
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Дата = Формат(ПараметрыСеанса.ВремяНачалаСеанса, "ДЛФ=DT");
    Ответственный = ПараметрыСеанса.ТекущийСотрудник;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаДокумента = Товары.Итог("Сумма");
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// регистр Товары/Продажи 
	Движения.Товары.Записывать = Истина;
	ТЗСвернутая = Товары.Выгрузить();
	ТЗСвернутая.Свернуть("Номенклатура", "Количество, Цена, Сумма");
	
	ТипТовар = Перечисления.ТипыНоменклатуры.Товар;
	СотрудникЗаписи = Ответственный;
	
	Для Каждого ТекСтрокаТовары Из ТЗСвернутая Цикл
		
		Если ТекСтрокаТовары.Номенклатура.ТипНоменклатуры = ТипТовар Тогда
			
			
			
			Движение = Движения.Товары.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;            
			Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
			Движение.Количество = ТекСтрокаТовары.Количество;
			//Движение.Стоимость = ТекСтрокаТовары.Сумма;
			Движение.Сотрудник = СотрудникЗаписи;
			Движение.Сумма = ТекСтрокаТовары.Сумма;
		
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры



