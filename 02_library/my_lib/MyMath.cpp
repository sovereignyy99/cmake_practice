/**
 * @Author: mp
 * @Date: 2022/4/24 17:02
 * @Last Modified by: mp
 * @Last Modified time: 2022/4/24 17:02
 */

#include "my_math/MyMath.h"
#include <iostream>

int MyAdd(int a, int b)
{
    int sum = a + b;
    std::cout << "MyAdd $: a + b = " << sum << std::endl;
    return sum;
}
