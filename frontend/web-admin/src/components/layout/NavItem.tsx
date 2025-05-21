'use client';

import { IconType } from 'react-icons';
import Link from 'next/link';
import { Flex, Icon, Text, useColorModeValue } from '@chakra-ui/react';

interface NavItemProps {
  icon: IconType;
  children: React.ReactNode;
  href: string;
}

export const NavItem = ({ icon, children, href }: NavItemProps) => {
  return (
    <Link href={href} style={{ textDecoration: 'none' }}>
      <Flex
        align="center"
        p="4"
        mx="4"
        borderRadius="lg"
        role="group"
        cursor="pointer"
        _hover={{
          bg: 'gray.100',
          color: 'gray.800',
        }}
      >
        <Icon
          mr="4"
          fontSize="16"
          as={icon}
        />
        <Text>{children}</Text>
      </Flex>
    </Link>
  );
}; 