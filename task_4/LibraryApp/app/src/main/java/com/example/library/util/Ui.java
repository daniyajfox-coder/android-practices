package com.example.library.util;

import android.content.Context;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

/** Небольшие помощники для программного создания виджетов в layoutContainer. */
public final class Ui {

    private Ui() {}

    public static int dp(Context c, int v) {
        return Math.round(TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP, v, c.getResources().getDisplayMetrics()));
    }

    private static LinearLayout.LayoutParams params(Context c, int topDp) {
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.topMargin = dp(c, topDp);
        return lp;
    }

    /** Текстовая метка. */
    public static TextView text(Context c, String s, int sp) {
        TextView tv = new TextView(c);
        tv.setText(s);
        tv.setTextSize(TypedValue.COMPLEX_UNIT_SP, sp);
        tv.setLayoutParams(params(c, 12));
        return tv;
    }

    /** Поле ввода с подсказкой и типом ввода (InputType.*). */
    public static EditText edit(Context c, String hint, int inputType) {
        EditText et = new EditText(c);
        et.setHint(hint);
        et.setInputType(inputType);
        et.setLayoutParams(params(c, 8));
        return et;
    }

    public static Button button(Context c, String s) {
        Button b = new Button(c);
        b.setText(s);
        b.setLayoutParams(params(c, 8));
        return b;
    }

    public static void add(LinearLayout parent, View... views) {
        for (View v : views) parent.addView(v);
    }

    public static void toast(Context c, String s) {
        Toast.makeText(c, s, Toast.LENGTH_SHORT).show();
    }

    /** Читает число из поля (запятая тоже допустима). Бросает NumberFormatException, если пусто/некорректно. */
    public static double num(EditText e) {
        String s = e.getText().toString().trim().replace(',', '.');
        if (s.isEmpty()) throw new NumberFormatException("empty");
        double d = Double.parseDouble(s);
        if (Double.isNaN(d) || Double.isInfinite(d)) throw new NumberFormatException("bad");
        return d;
    }

    public static String str(EditText e) {
        return e.getText().toString().trim();
    }

    public static void ok(TextView tv, String s) {
        tv.setTextColor(Color.parseColor("#2E7D32"));
        tv.setText(s);
    }

    public static void err(TextView tv, String s) {
        tv.setTextColor(Color.RED);
        tv.setText(s);
    }
}
