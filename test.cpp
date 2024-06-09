
#define _DISABLE_CONSTEXPR_MUTEX_CONSTRUCTOR

#include <mutex>
#include <iostream>
int main()
{
    std::cout << "1" << std::flush << std::endl;
    std::mutex m;
    std::cout << "2" << std::flush << std::endl;
    std::lock_guard<std::mutex> lock(m);
    std::cout << "3" << std::flush << std::endl;
    return EXIT_SUCCESS;
}
