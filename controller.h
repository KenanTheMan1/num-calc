#pragma once
#include <QObject>
#include <QVector>

class Controller : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool finished READ finished NOTIFY finishedChanged)
    Q_PROPERTY(double average READ average NOTIFY finishedChanged)

public:
    explicit Controller(QObject *parent = nullptr);

    Q_INVOKABLE void addDigit(int digit);
    Q_INVOKABLE void finish();
    Q_INVOKABLE void reset();

    bool finished() const;
    double average() const;

signals:
    void cleared();
    void finishedChanged();

private:
    QVector<int> m_values;
    const int m_maxTrials = 14;
    bool m_finished = false;
};
