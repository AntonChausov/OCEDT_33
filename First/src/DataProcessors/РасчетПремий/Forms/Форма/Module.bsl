
&НаСервере
Процедура РассчитатьНаСервере()
	
	РезультатРасчета.Очистить();
	ЗапросТоваровИУслуг = Новый Запрос;

	// Перебираем Регистры Накопления: Товары и Продажи в разрезе сотрудников
	ЗапросТоваровИУслуг.Текст = "ВЫБРАТЬ
								|	ТоварыПродажи.Сотрудник КАК Сотрудник,
								|	СУММА(ТоварыПродажи.ПроданоТоваров) КАК ПроданоТоваров,
								|	СУММА(ТоварыПродажи.ПроданоУслуг) КАК ПроданоУслуг,
								|	СУММА(0) КАК Премия
								|ИЗ (
								|	ВЫБРАТЬ
								|		Товары.Сотрудник КАК Сотрудник,
	                            |		Товары.Стоимость КАК ПроданоТоваров,
	                            |		0 КАК ПроданоУслуг
								|	ИЗ
	                            |		РегистрНакопления.Товары КАК Товары
	                            |	ГДЕ
	                            |		Товары.Период МЕЖДУ &ПериодНачало И &ПериодКонец
	                            |	
	                            |	ОБЪЕДИНИТЬ ВСЕ
	                            |	
								|	ВЫБРАТЬ
								|		Продажи.Сотрудник КАК Сотрудник,
	                            |		0 КАК ПроданоТоваров,
	                            |		Продажи.Сумма КАК ПроданоУслуг
								|	ИЗ
	                            |		РегистрНакопления.Продажи КАК Продажи
	                            |	ГДЕ
	                            |		Продажи.Период МЕЖДУ &ПериодНачало И &ПериодКонец
								|	) КАК ТоварыПродажи
	                            |
	                            |СГРУППИРОВАТЬ ПО
	                            |	ТоварыПродажи.Сотрудник";
	ЗапросТоваровИУслуг.УстановитьПараметр("ПериодНачало", Период.ДатаНачала);
	ЗапросТоваровИУслуг.УстановитьПараметр("ПериодКонец", Период.ДатаОкончания);
	
	Выборка = ЗапросТоваровИУслуг.Выполнить().Выбрать();
	
	// Заполняем результатом запроса ТЗ на форме
	Пока Выборка.Следующий() Цикл
		
        // Рассчитываем премию
		ПремияЗаТовар = Выборка.ПроданоТоваров * (ДляТоваров / 100);
		ПремияЗаУслуги = Выборка.ПроданоУслуг * (ДляУслуг / 100);
		ОбщаяПремия = ПремияЗаТовар + ПремияЗаУслуги;
        // Заполняем
    	СтрокаТЧ = РезультатРасчета.Добавить();
    	ЗаполнитьЗначенияСвойств(СтрокаТЧ, Выборка);
		СтрокаТЧ.Премия = ОбщаяПремия;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	РассчитатьНаСервере();
КонецПроцедуры
