import { Box, Container, Heading, SimpleGrid, Stat, StatLabel, StatNumber, StatHelpText, StatArrow } from '@chakra-ui/react';
import DashboardLayout from '../components/layout/DashboardLayout';

export default function Home() {
  return (
    <DashboardLayout>
      <Container maxW="container.xl" py={5}>
        <Heading mb={8}>대시보드</Heading>
        
        <SimpleGrid columns={{ base: 1, md: 2, lg: 4 }} spacing={6}>
          <Stat
            px={4}
            py={5}
            shadow="xl"
            border="1px solid"
            borderColor="gray.200"
            rounded="lg"
          >
            <StatLabel>전체 학원 수</StatLabel>
            <StatNumber>45</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              23.36%
            </StatHelpText>
          </Stat>

          <Stat
            px={4}
            py={5}
            shadow="xl"
            border="1px solid"
            borderColor="gray.200"
            rounded="lg"
          >
            <StatLabel>전체 학생 수</StatLabel>
            <StatNumber>1,234</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              9.05%
            </StatHelpText>
          </Stat>

          <Stat
            px={4}
            py={5}
            shadow="xl"
            border="1px solid"
            borderColor="gray.200"
            rounded="lg"
          >
            <StatLabel>활성 구독</StatLabel>
            <StatNumber>42</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              5.14%
            </StatHelpText>
          </Stat>

          <Stat
            px={4}
            py={5}
            shadow="xl"
            border="1px solid"
            borderColor="gray.200"
            rounded="lg"
          >
            <StatLabel>월간 수익</StatLabel>
            <StatNumber>₩12,345,678</StatNumber>
            <StatHelpText>
              <StatArrow type="increase" />
              12.5%
            </StatHelpText>
          </Stat>
        </SimpleGrid>
      </Container>
    </DashboardLayout>
  );
} 