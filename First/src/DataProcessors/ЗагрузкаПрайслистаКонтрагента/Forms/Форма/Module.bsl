
&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ВыборФайлаАсинхронно();
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВыборФайлаАсинхронно()
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = "ВыберитеФайл";
	ДиалогВыбора.МножественныйВыбор = Ложь;
	ДиалогВыбора.Фильтр = "Все файлы|*.*|Текстовые файлы|*.csv";
	ДиалогВыбора.ИндексФильтра = 1;
	ДиалогВыбора.Каталог = "C:\";
	
	РезультатВыбора = Ждать ДиалогВыбора.ВыбратьАсинх();
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Объект.ПутьКФайлу = РезультатВыбора[0];
	

КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	ПрочитатьФайлАсинх();
КонецПроцедуры    


&НаКлиенте
Асинх Процедура ПрочитатьФайлАсинх()  
	
	
	// Проверка заполнения Контрагента
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Сообщить("Нужно указать Контрагента");
		Возврат;
	КонецЕсли;
	
	// Проверка заполнения пути к файлу
	Если НЕ ЗначениеЗаполнено(Объект.ПутьКФайлу) Тогда
		Сообщить("Нужно указать Путь к файлу");
		Возврат;
	КонецЕсли;
	
	// Проверка наличия файла по пути
	ОписаниеФайла = Новый Файл(Объект.ПутьКФайлу);
	ФайлСуществует = Ждать ОписаниеФайла.СуществуетАсинх();
	Если НЕ ФайлСуществует Тогда
		Сообщить("Файл не найден");
		Возврат;
	КонецЕсли;
	
	// Переносим файл на сервер
	ОписаниеФайла = Ждать ПоместитьФайлНаСерверАсинх(, , , Объект.ПутьКФайлу, УникальныйИдентификатор);
	Если ОписаниеФайла = Неопределено ИЛИ ОписаниеФайла.ПомещениеФайлаОтменено Тогда
		Возврат;
	КонецЕсли;
	АдресВХранилище = ОписаниеФайла.Адрес;
	РасширениеФайла = ОписаниеФайла.СсылкаНаФайл.Расширение;
	
	// Возвращаем проверку номенклатуры
	РезультатПроверки = Новый Структура("ПроверкаНоменклатуры", Истина, Неопределено);
	// ДанныеФайла только с сервера
	ДанныеФайлаСервер = Новый Массив;
	// Запускаем заполнение
	ОбработатьФайлНаСервере(АдресВХранилище, РасширениеФайла, ДанныеФайлаСервер, РезультатПроверки);
	
	// Далее все проверки как и с предыдущего задания, только меняем переменные
	
	// Показываем содержимое файла
	Объект.СодержаниеФайла.ПрочитатьАсинх(Объект.ПутьКФайлу);
	
	
	//ДанныеФайла = Ждать ПрочитатьФайл(Объект.ПутьКФайлу); // Выключаем для выполнения этих действий на сервере
    //ПроверкаНаСуществованиеНоменклатуры = Ждать НайтиНоменклатуру(ДанныеФайла); // Выключаем для выполнения этих действий на сервере
	
	// Вопрос пользователю
	//Если ПроверкаНаСуществованиеНоменклатуры = Ложь Тогда // Выключаем для выполнения этих действий на сервере
	Если РезультатПроверки.ПроверкаНоменклатуры = Ложь Тогда 
		ТекстВопроса = "Найдена отсутствующая в справочнике номенклатура. Продолжить регистрацию документов по остальным номенклатурам?";
		ВариантыОтвета = Новый СписокЗначений;
		ВариантыОтвета.Добавить(1, "Не загружать цены");
		ВариантыОтвета.Добавить(2, "Не создавать документ");
		ВариантыОтвета.Добавить(3, "Создавать номенклатуру");
		ОтветПользователя = Ждать ВопросАсинх(ТекстВопроса, ВариантыОтвета);
	Иначе ОтветПользователя = 1;
	КонецЕсли;
	
	// Нужно ли документ сразу провести
	Если Элементы.СогласоватьЦены.Доступность = Истина И СогласоватьЦены = Истина Тогда
		  ПровестиДокумент = Истина;
	Иначе ПровестиДокумент = Ложь;
	КонецЕсли;
	
	// Если пользователь ответил "Не загружать цены" (просто создать документ) или "Создавать номенклатуру" (создать документ + номенклатуру)
	Если ОтветПользователя = 1 ИЛИ ОтветПользователя = 3 Тогда
		//СоздатьДокумент(Объект.Контрагент, ДанныеФайла, ПровестиДокумент, ОтветПользователя); // Выключаем для выполнения этих действий на сервере
		СоздатьДокумент(Объект.Контрагент, ДанныеФайлаСервер, ПровестиДокумент, ОтветПользователя);
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьФайлНаСервере(АдресВХранилище, РасширениеФайла, ДанныеФайлаСервер, РезультатПроверки)
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(РасширениеФайла);
	
	ДанныеФайла = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ДанныеФайла.Записать(ИмяВременногоФайла);
	
	/////////////////////////////

	ТекстовыйФайлЗагрузки = Новый ТекстовыйДокумент;
	ТекстовыйФайлЗагрузки.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);

	РазборФайла = Новый Массив;

	//Прочитаем строки файла
	Для НомерСтроки = 1 по ТекстовыйФайлЗагрузки.КоличествоСтрок() Цикл

		НоваяСтрока = ТекстовыйФайлЗагрузки.ПолучитьСтроку(НомерСтроки);

		// «парсим» строки по ";"
		// ищем позицию символа-разделителя
		Позиция = Найти(НоваяСтрока, ";");

		// Получаем из строки наименование номенклатуры и цену
		// Наименование перед символом-разделителем, цена - после
		НаименованиеНоменклатуры = Сред(НоваяСтрока, 1, Позиция - 1);
		Цена = Сред(НоваяСтрока, Позиция + 1);

		// Готовим коллекцию данных для последующего заполнения документа
		ДанныеСтрокиДокумента = Новый Структура;
		ДанныеСтрокиДокумента.Вставить("НаименованиеНоменклатуры", НаименованиеНоменклатуры);
		ДанныеСтрокиДокумента.Вставить("Цена", Цена);

		РазборФайла.Добавить(ДанныеСтрокиДокумента);
		
		// Проверка номенклатуры
		Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию(НаименованиеНоменклатуры);

		// Если номенклатура не найдена, то Ложь
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
				РезультатПроверки.ПроверкаНоменклатуры = Ложь;
		Иначе РезультатПроверки.ПроверкаНоменклатуры = Истина;
		КонецЕсли;


	КонецЦикла;	
	
	ДанныеФайлаСервер = РазборФайла;
	/////////////////////////////
	
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьИзВременногоХранилища(АдресВХранилище);
КонецПроцедуры


&НаКлиенте
Асинх Функция ПрочитатьФайл(ПутьКФайлу)

	ТекстовыйФайлЗагрузки = Новый ТекстовыйДокумент;
	Ждать ТекстовыйФайлЗагрузки.ПрочитатьАсинх(ПутьКФайлу, КодировкаТекста.UTF8);
	
	// Показываем содержимое файла
	//Объект.СодержаниеФайла.ПрочитатьАсинх(Объект.ПутьКФайлу);

	Результат = Новый Массив;

	//Прочитаем строки файла
	Для НомерСтроки = 1 по ТекстовыйФайлЗагрузки.КоличествоСтрок() Цикл

		НоваяСтрока = ТекстовыйФайлЗагрузки.ПолучитьСтроку(НомерСтроки);

		// «парсим» строки по ";"
		// ищем позицию символа-разделителя
		Позиция = Найти(НоваяСтрока, ";");

		// Получаем из строки наименование номенклатуры и цену
		// Наименование перед символом-разделителем, цена - после
		НаименованиеНоменклатуры = Сред(НоваяСтрока, 1, Позиция - 1);
		Цена = Сред(НоваяСтрока, Позиция + 1);

		// Готовим коллекцию данных для последующего заполнения документа
		ДанныеСтрокиДокумента = Новый Структура;
		ДанныеСтрокиДокумента.Вставить("НаименованиеНоменклатуры", НаименованиеНоменклатуры);
		ДанныеСтрокиДокумента.Вставить("Цена", Цена);

		Результат.Добавить(ДанныеСтрокиДокумента);

	КонецЦикла;	

	Возврат Результат;

КонецФункции


&НаСервереБезКонтекста
Процедура СоздатьДокумент(Контрагент, ДанныеФайла, ПровестиДокумент, ОтветПользователя)

	// Создаём новый документ
	ДокументЦены = Документы.УстановкаЦен.СоздатьДокумент();
	ДокументЦены.Дата = ТекущаяДата();
	ДокументЦены.Контрагент = Контрагент;
	ДокументЦены.Комментарий = "Загружен из файла";
	ДокументЦены.Ответственный = ПараметрыСеанса.ТекущийСотрудник;

	ШаблонСообщения = НСтр("ru = 'Номенклатура: %1 не найдена'");
	
	// Обходим коллекцию с данными файла и заполняем строки табличной части
	Для Каждого ДанныеСтроки Из ДанныеФайла Цикл

		Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию(ДанныеСтроки.НаименованиеНоменклатуры);

		// Если номенклатура не найдена, то сообщаем об этом пользователю
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
			
			// Выбрано "Не загружать цены"
			Если ОтветПользователя = 1 Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон(ШаблонСообщения, ДанныеСтроки.НаименованиеНоменклатуры);
				Сообщение.Сообщить();
				Продолжить;       
			// Выбрано "Создавать номенклатуру"
			ИначеЕсли ОтветПользователя = 3 Тогда
				НоваяНоменклатура = Справочники.Номенклатура.СоздатьЭлемент();
				НоваяНоменклатура.Наименование = ДанныеСтроки.НаименованиеНоменклатуры;
    			НоваяНоменклатура.Записать();
				// Проверяем после создания новой номенклатуры
				ПроверкаСозданияНоменклатуры = Справочники.Номенклатура.НайтиПоНаименованию(ДанныеСтроки.НаименованиеНоменклатуры);
				Если Строка(ПроверкаСозданияНоменклатуры) = Строка(ДанныеСтроки.НаименованиеНоменклатуры) Тогда
					Номенклатура = НоваяНоменклатура.Ссылка;
					Сообщить(СтрШаблон("Создана новая номенклатура: %1", ПроверкаСозданияНоменклатуры));
				Иначе Сообщить(СтрШаблон("Новая номенклатура: ""%1"" не создана", ДанныеСтроки.НаименованиеНоменклатуры));
				КонецЕсли;
			КонецЕсли;

		КонецЕсли;

		НоваяСтрокаТЧ = ДокументЦены.Цены.Добавить();
		НоваяСтрокаТЧ.Номенклатура = Номенклатура;
		НоваяСтрокаТЧ.Цена = ДанныеСтроки.Цена;
		
	КонецЦикла;	
	
	// Создаем документ
	// Проверяем, надо ли документ провести
	Если ПровестиДокумент = Истина Тогда
		  ДокументЦены.Согласовано = Истина;
		  ДокументЦены.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Оперативный);
	Иначе ДокументЦены.Записать();
	КонецЕсли;

	Сообщить(СтрШаблон("Создан документ с номером: %1", ДокументЦены.Номер));
	
КонецПроцедуры


&НаСервере
Функция НайтиНоменклатуру(ДанныеФайла)
	
	// Обходим коллекцию с данными файла и проверяем, есть ли номенклатура
	Для Каждого ДанныеСтроки Из ДанныеФайла Цикл
		
		Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию(ДанныеСтроки.НаименованиеНоменклатуры);

		// Если номенклатура не найдена, то выходим
		Если Не ЗначениеЗаполнено(Номенклатура) Тогда
				Результат = Ложь;
				Возврат Результат;
		Иначе Результат = Истина;
		КонецЕсли;

	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции


&НаСервере
Функция ИмяСотрудника() Экспорт
	Если РольДоступна("ПолныеПрава") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;   
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.СогласоватьЦены.Доступность = ИмяСотрудника(); 
КонецПроцедуры



