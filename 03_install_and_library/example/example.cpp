/**
 * @Author: mp
 * @Date: 2022/4/24 17:02
 * @Last Modified by: mp
 * @Last Modified time: 2022/4/24 17:02
 */

#include "my_lib/my_lib.h"
#include <iostream>

#define CNT_MAX 10 //!< The maxium number of print

//*****************************************************************************
//
//! \brief Write one byte to special register
//!
//! This function is to write one byte to LIS302DL register,one byte will be
//! writen in appointed address.
//!
//! \param RegAddr specifies the target register address.
//! \param Data is the data written to target register.
//!
//! \return Indicate the status of operation which can be one of the following
//! value \b 0 or  \b -1 .
//!
//! \note This function is used by internal, user MUST NOT call it in your
//!  Application.
//
//*****************************************************************************
static int Foo(uint8_t RegAddr, uint8_t Data)
{
    int retv = 0;

    // Begin to I2C Transfer
    // first send START signal to control I2C bus
    // then send 7-bit address and R/W bit to I2C salve
    // at last send target register address
    retv = MyAdd(1, 2);
    if (retv != 0)
    {
        return (-1);
    }

    // Send the wanted data to I2C bus
    // then Send STOP signal to release I2C bus
    retv = MyAdd(1, 2);
    if (retv != 0)
    {
        return (-1);
    }

    return (0);
}

/*! \fn int Bar(const char *pathname,int flags)
   \brief Opens a file descriptor.
   
   \param pathname The name of the descriptor.
   \param flags Opening flags.
*/
int Bar(const char *pathname, int flags) { return -2; }

//! Application Entry
int main()
{
    int c = MyAdd(1, 2);

    int d = Foo(1, 2);
    int e = Bar("abc", 20);

    std::cout << "Hello, world." << std::endl;
    std::cout << "main $: a + b = " << c << std::endl;
    std::cout << "main $: Foo() = " << d << std::endl;
    std::cout << "main $: Bar() = " << e << std::endl;
}
