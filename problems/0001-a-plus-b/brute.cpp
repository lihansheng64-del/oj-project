// 暴力解：用 __int128 计算，作为对拍的标准答案
#include <bits/stdc++.h>
using namespace std;

int main() {
    long long a, b;
    cin >> a >> b;
    __int128 s = (__int128)a + b;
    if (s == 0) { cout << 0 << '\n'; return 0; }
    bool neg = s < 0;
    if (neg) s = -s;
    string out;
    while (s > 0) { out += char('0' + s % 10); s /= 10; }
    if (neg) out += '-';
    reverse(out.begin(), out.end());
    cout << out << '\n';
    return 0;
}
