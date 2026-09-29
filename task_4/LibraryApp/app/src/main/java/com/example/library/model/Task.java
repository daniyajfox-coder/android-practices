package com.example.library.model;

/**
 * Модель одного задания в "библиотеке".
 */
public class Task {

    private final int number;
    private final String title;
    private final int level; // 1, 2 или 3
    private final Class<?> activityClass;

    public Task(int number, String title, int level, Class<?> activityClass) {
        this.number = number;
        this.title = title;
        this.level = level;
        this.activityClass = activityClass;
    }

    public int getNumber() {
        return number;
    }

    public String getTitle() {
        return title;
    }

    public int getLevel() {
        return level;
    }

    public Class<?> getActivityClass() {
        return activityClass;
    }
}
