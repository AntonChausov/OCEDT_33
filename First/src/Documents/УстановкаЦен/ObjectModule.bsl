
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	Дата = Формат(ПараметрыСеанса.ВремяНачалаСеанса, "ДЛФ=DT");
    Ответственный = ПараметрыСеанса.ТекущийСотрудник;
	
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Согласовано Тогда
		  Отказ = Истина;
		  Сообщить("Необходимо установить галку Согласовано (возможно только с Полными Правами)");
	Иначе Отказ = Ложь;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр ЦеныПоставщиков
	Движения.ЦеныПоставщиков.Записывать = Истина;
	ТЗСвернутая = Цены.Выгрузить();

	// Ищем дубли
	ДубльЗаписи = Ложь;
	Для Каждого ТекСтрокаЦены Из ТЗСвернутая Цикл
		Для Каждого ТекСтрокаЦеныДубль Из ТЗСвернутая Цикл
			Если ТекСтрокаЦеныДубль.Номенклатура = ТекСтрокаЦены.Номенклатура И 
				 ТЗСвернутая.Индекс(ТекСтрокаЦеныДубль) <> ТЗСвернутая.Индекс(ТекСтрокаЦены) Тогда
				 ДубльЗаписи = Истина;
				 ДубльНоменклатуры = ТекСтрокаЦены.Номенклатура;
			 КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	// Пишем, если дублей нет
	Если ДубльЗаписи = Ложь Тогда
		Для Каждого ТекСтрокаЦены Из ТЗСвернутая Цикл
		
			Если ДубльЗаписи = Ложь Тогда
				Движение = Движения.ЦеныПоставщиков.Добавить();
				Движение.Период = Дата;
				Движение.Номенклатура = ТекСтрокаЦены.Номенклатура;
				Движение.Контрагент = Контрагент;
				Движение.Цена = ТекСтрокаЦены.Цена;
				Движение.Ответственный = Ответственный;
			КонецЕсли;
		КонецЦикла;
	// Сообщаем, если нашли дубли
	Иначе Сообщить(СтрШаблон("В таблице цен дублируется Номенклатура ""%1""", ДубльНоменклатуры));
	КонецЕсли;

КонецПроцедуры




