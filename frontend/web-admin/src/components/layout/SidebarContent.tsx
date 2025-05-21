'use client';

import React from 'react';
import { Box, VStack, Link, Text } from '@chakra-ui/react';
import { usePathname } from 'next/navigation';

interface NavItemProps {
  href: string;
  children: React.ReactNode;
}

function NavItem({ href, children }: NavItemProps) {
  const pathname = usePathname();
  const isActive = pathname === href;

  return (
    <Link
      href={href}
      style={{ textDecoration: 'none' }}
      _focus={{ boxShadow: 'none' }}
    >
      <Box
        display="flex"
        alignItems="center"
        p={3}
        mx={4}
        borderRadius="lg"
        role="group"
        cursor="pointer"
        bg={isActive ? 'gray.800' : 'transparent'}
        color={isActive ? 'white' : 'gray.700'}
        _hover={{
          bg: isActive ? 'gray.700' : 'gray.100',
        }}
      >
        {children}
      </Box>
    </Link>
  );
}

export function SidebarContent() {
  return (
    <Box h="full" py={5}>
      <VStack spacing={1} align="stretch">
        <NavItem href="/">대시보드</NavItem>
        <NavItem href="/academies">학원 관리</NavItem>
        <NavItem href="/students">학생 관리</NavItem>
        <NavItem href="/contents">콘텐츠 관리</NavItem>
        <NavItem href="/reports">리포트</NavItem>
        <NavItem href="/settings">설정</NavItem>
      </VStack>
    </Box>
  );
} 