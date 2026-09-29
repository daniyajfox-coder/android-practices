package com.example.library;

import android.content.res.Configuration;
import android.os.Bundle;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.library.adapter.TaskAdapter;
import com.example.library.model.Task;

import com.example.library.tasks.task01.Task01Activity;
import com.example.library.tasks.task02.Task02Activity;
import com.example.library.tasks.task03.Task03Activity;
import com.example.library.tasks.task04.Task04Activity;
import com.example.library.tasks.task05.Task05Activity;
import com.example.library.tasks.task06.Task06Activity;
import com.example.library.tasks.task07.Task07Activity;
import com.example.library.tasks.task08.Task08Activity;
import com.example.library.tasks.task09.Task09Activity;
import com.example.library.tasks.task10.Task10Activity;
import com.example.library.tasks.task11.Task11Activity;
import com.example.library.tasks.task12.Task12Activity;
import com.example.library.tasks.task13.Task13Activity;
import com.example.library.tasks.task14.Task14Activity;
import com.example.library.tasks.task15.Task15Activity;
import com.example.library.tasks.task16.Task16Activity;
import com.example.library.tasks.task17.Task17Activity;
import com.example.library.tasks.task18.Task18Activity;
import com.example.library.tasks.task19.Task19Activity;
import com.example.library.tasks.task20.Task20Activity;
import com.example.library.tasks.task21.Task21Activity;
import com.example.library.tasks.task22.Task22Activity;
import com.example.library.tasks.task23.Task23Activity;
import com.example.library.tasks.task24.Task24Activity;
import com.example.library.tasks.task25.Task25Activity;
import com.example.library.tasks.task26.Task26Activity;
import com.example.library.tasks.task27.Task27Activity;
import com.example.library.tasks.task28.Task28Activity;
import com.example.library.tasks.task29.Task29Activity;
import com.example.library.tasks.task30.Task30Activity;

import java.util.ArrayList;
import java.util.List;

/** Каталог заданий. Число колонок зависит от ширины экрана. */
public class MainActivity extends AppCompatActivity {

    private static final int CARD_MIN_WIDTH_DP = 170;

    private final List<Task> allTasks = new ArrayList<>();
    private TaskAdapter adapter;
    private RecyclerView recyclerView;
    private GridLayoutManager layoutManager;
    private int currentFilter = 0; // 0 = все, 1/2/3 = уровень

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        buildTaskList();

        recyclerView = findViewById(R.id.recyclerTasks);
        int spanCount = calculateSpanCount();
        layoutManager = new GridLayoutManager(this, spanCount);
        recyclerView.setLayoutManager(layoutManager);

        adapter = new TaskAdapter(this, allTasks);
        recyclerView.setAdapter(adapter);

        Button btnAll = findViewById(R.id.btnFilterAll);
        Button btnLevel1 = findViewById(R.id.btnFilterLevel1);
        Button btnLevel2 = findViewById(R.id.btnFilterLevel2);
        Button btnLevel3 = findViewById(R.id.btnFilterLevel3);

        btnAll.setOnClickListener(v -> applyFilter(0));
        btnLevel1.setOnClickListener(v -> applyFilter(1));
        btnLevel2.setOnClickListener(v -> applyFilter(2));
        btnLevel3.setOnClickListener(v -> applyFilter(3));
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (layoutManager != null) {
            layoutManager.setSpanCount(calculateSpanCount());
        }
    }

    private int calculateSpanCount() {
        float density = getResources().getDisplayMetrics().density;
        int widthPx = getResources().getDisplayMetrics().widthPixels;
        int widthDp = (int) (widthPx / density);
        int span = widthDp / CARD_MIN_WIDTH_DP;
        return Math.max(span, 1);
    }

    private void applyFilter(int level) {
        currentFilter = level;
        if (level == 0) {
            adapter.updateData(allTasks);
            return;
        }
        List<Task> filtered = new ArrayList<>();
        for (Task t : allTasks) {
            if (t.getLevel() == level) {
                filtered.add(t);
            }
        }
        adapter.updateData(filtered);
    }

    private void buildTaskList() {
        allTasks.add(new Task(1, "Светофор", 1, Task01Activity.class));
        allTasks.add(new Task(2, "Генератор случайных чисел", 1, Task02Activity.class));
        allTasks.add(new Task(3, "Мини-тест с одной кнопкой", 1, Task03Activity.class));
        allTasks.add(new Task(4, "Переключатель видимости", 1, Task04Activity.class));
        allTasks.add(new Task(5, "Инвертор текста", 1, Task05Activity.class));
        allTasks.add(new Task(6, "Калькулятор возраста питомца", 1, Task06Activity.class));
        allTasks.add(new Task(7, "Счетчик символов", 1, Task07Activity.class));
        allTasks.add(new Task(8, "Симулятор фонарика", 1, Task08Activity.class));
        allTasks.add(new Task(9, "Конвертер см в дюймы", 1, Task09Activity.class));
        allTasks.add(new Task(10, "Определитель четности", 1, Task10Activity.class));
        allTasks.add(new Task(11, "Индекс массы тела (ИМТ)", 2, Task11Activity.class));
        allTasks.add(new Task(12, "Калькулятор расхода топлива", 2, Task12Activity.class));
        allTasks.add(new Task(13, "Конвертер температур", 2, Task13Activity.class));
        allTasks.add(new Task(14, "Простой калькулятор (4 действия)", 2, Task14Activity.class));
        allTasks.add(new Task(15, "Таймер скидки магазина", 2, Task15Activity.class));
        allTasks.add(new Task(16, "Конвертер валют", 2, Task16Activity.class));
        allTasks.add(new Task(17, "Генератор надежного PIN-кода", 2, Task17Activity.class));
        allTasks.add(new Task(18, "Тест на знание столиц", 2, Task18Activity.class));
        allTasks.add(new Task(19, "Калькулятор времени в пути", 2, Task19Activity.class));
        allTasks.add(new Task(20, "Оценщик надежности пароля", 2, Task20Activity.class));
        allTasks.add(new Task(21, "Экран входа и Личный кабинет", 3, Task21Activity.class));
        allTasks.add(new Task(22, "Оформление заказа пиццы", 3, Task22Activity.class));
        allTasks.add(new Task(23, "Квиз из двух вопросов", 3, Task23Activity.class));
        allTasks.add(new Task(24, "Конструктор визитки мастера", 3, Task24Activity.class));
        allTasks.add(new Task(25, "Дневник заметок", 3, Task25Activity.class));
        allTasks.add(new Task(26, "Калькулятор автокредита", 3, Task26Activity.class));
        allTasks.add(new Task(27, "Электронный билет на поезд", 3, Task27Activity.class));
        allTasks.add(new Task(28, "Анкета спортивного трекера", 3, Task28Activity.class));
        allTasks.add(new Task(29, "Мини-словарь терминов", 3, Task29Activity.class));
        allTasks.add(new Task(30, "Портфолио студента", 3, Task30Activity.class));
    }
}
