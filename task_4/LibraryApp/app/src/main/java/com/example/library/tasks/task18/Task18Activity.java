package com.example.library.tasks.task18;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.library.R;
import com.example.library.util.Ui;
import java.util.Random;

/** Тест на знание столиц */
public class Task18Activity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_single);

        ((TextView) findViewById(R.id.tvTaskTitle)).setText(R.string.task18_title);
        ((TextView) findViewById(R.id.tvTaskDesc)).setText(R.string.task18_desc);
        LinearLayout c = findViewById(R.id.layoutContainer);

        final String[] countries = {"Франция", "Германия", "Италия", "Испания", "Япония", "Канада", "Египет", "Польша"};
        final String[] capitals = {"Париж", "Берлин", "Рим", "Мадрид", "Токио", "Оттава", "Каир", "Варшава"};
        final int[] state = {0, 0}; // индекс вопроса, очки
        final Random rnd = new Random();
        final TextView tvCountry = Ui.text(this, "", 22);
        final Button[] opts = {Ui.button(this, ""), Ui.button(this, ""), Ui.button(this, "")};
        final TextView tvScore = Ui.text(this, "", 18);
        final Button restart = Ui.button(this, "Начать заново");
        restart.setVisibility(View.GONE);
        Runnable show = new Runnable() {
            @Override public void run() {
                if (state[0] >= countries.length) {
                    tvCountry.setText("Тест окончен!");
                    for (Button b : opts) b.setVisibility(View.GONE);
                    tvScore.setText("Ваш результат: " + state[1] + " из " + countries.length);
                    restart.setVisibility(View.VISIBLE);
                    return;
                }
                int q = state[0];
                tvCountry.setText("Столица страны: " + countries[q] + "?");
                String[] choice = new String[3];
                choice[0] = capitals[q];
                int k = 1;
                while (k < 3) {
                    String cand = capitals[rnd.nextInt(capitals.length)];
                    boolean dup = false;
                    for (int i = 0; i < k; i++) if (choice[i].equals(cand)) dup = true;
                    if (!dup) choice[k++] = cand;
                }
                for (int i = 2; i > 0; i--) { // перемешивание
                    int j = rnd.nextInt(i + 1);
                    String t = choice[i]; choice[i] = choice[j]; choice[j] = t;
                }
                for (int i = 0; i < 3; i++) { opts[i].setText(choice[i]); opts[i].setVisibility(View.VISIBLE); }
                tvScore.setText("Очки: " + state[1] + " | Вопрос " + (q + 1) + " из " + countries.length);
                restart.setVisibility(View.GONE);
            }
        };
        View.OnClickListener l = v -> {
            String answer = ((Button) v).getText().toString();
            if (answer.equals(capitals[state[0]])) state[1]++;
            state[0]++;
            show.run();
        };
        for (Button b : opts) b.setOnClickListener(l);
        restart.setOnClickListener(v -> { state[0] = 0; state[1] = 0; show.run(); });
        Ui.add(c, tvCountry, opts[0], opts[1], opts[2], tvScore, restart);
        show.run();
    }
}
