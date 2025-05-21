'use client';

import React from 'react';
import {
  Box,
  Container,
  Heading,
  SimpleGrid,
  Stat,
  StatLabel,
  StatNumber,
  StatHelpText,
  StatArrow,
} from '@chakra-ui/react';
import DashboardLayout from '../components/layout/DashboardLayout';

export default function Home() {
  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Heading mb={8}>대시보드</Heading>
        <SimpleGrid columns={{ base: 1, md: 2, lg: 4 }} spacing={6}>
          <Stat>
            <StatLabel>전체 학원 수</StatLabel>
            <StatNumber>45</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              23.36%
            </StatHelpText>
          </Stat>
          <Stat>
            <StatLabel>전체 학생 수</StatLabel>
            <StatNumber>1,234</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              9.05%
            </StatHelpText>
          </Stat>
          <Stat>
            <StatLabel>활성 구독</StatLabel>
            <StatNumber>890</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              5.27%
            </StatHelpText>
          </Stat>
          <Stat>
            <StatLabel>월간 수익</StatLabel>
            <StatNumber>₩89,000,000</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              12.45%
            </StatHelpText>
          </Stat>
        </SimpleGrid>
      </Container>
    </DashboardLayout>
  );
} 