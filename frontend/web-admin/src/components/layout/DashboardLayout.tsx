'use client';

import React from 'react';
import { Box, Flex } from '@chakra-ui/react';
import { SidebarContent } from './SidebarContent';

interface DashboardLayoutProps {
  children: React.ReactNode;
}

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  return (
    <Flex minH="100vh">
      <Box w="250px" bg="white" boxShadow="sm">
        <SidebarContent />
      </Box>
      <Box flex="1" bg="gray.50">
        {children}
      </Box>
    </Flex>
  );
} 