#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent) {}

void Controller::addDigit(int digit) {
    if (m_finished) return;

    m_values.append(digit);
    emit cleared();

    if (m_values.size() >= m_maxTrials) {
        finish();
    }
}

void Controller::finish() {
    if (m_finished) return;
    m_finished = true;
    emit finishedChanged();
}

bool Controller::finished() const {
    return m_finished;
}

double Controller::average() const {
    if (m_values.isEmpty()) return 0.0;
    int sum = 0;
    for (int v : m_values) sum += v;
    return double(sum) / m_values.size();
}

void Controller::reset() {
    m_finished = false;
    m_values.clear();
    emit finishedChanged();
}
